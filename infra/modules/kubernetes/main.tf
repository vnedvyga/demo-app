locals {
  aws_lb_sa_name = "aws-load-balancer-controller-sa"
}

resource "flux_bootstrap_git" "this" {
  embedded_manifests      = true
  path                    = var.gitops_path
  version                 = var.flux_version
  kustomization_override  = file("${path.root}/resources/flux-kustomization-patch.yaml")
}

module "aws_lb_controller_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.5"

  name = "aws-lbc"

  attach_aws_lb_controller_policy = true

  associations = {
    this = {
      cluster_name    = var.cluster_name
      namespace       = "kube-system"
      service_account = local.aws_lb_sa_name
    }
  }
}

resource "helm_release" "aws_lb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.aws_lb_controller_version

  values = [
    templatefile("${path.module}/resources/aws-lb-controller-values.yaml.tmpl", {
      cluster_name = var.cluster_name
      sa_name      = local.aws_lb_sa_name
      sa_role      = module.aws_lb_controller_pod_identity.iam_role_arn
      vpc_id       = var.aws_vpc_id
    })
  ]
}

resource "kubernetes_namespace" "api_gateway_namespace" {
  metadata {
    name = var.api_gateway_namespace
  }
}

resource "helm_release" "contour" {
  name       = var.api_gateway_name
  namespace  = kubernetes_namespace.api_gateway_namespace.metadata[0].name
  repository = "https://projectcontour.github.io/helm-charts/"
  chart      = "contour"
  version    = var.contour_version

  values = [
    templatefile("${path.module}/resources/contour-values.yaml.tmpl", {
      agw_name      = var.api_gateway_name
      agw_namespace = kubernetes_namespace.api_gateway_namespace.metadata[0].name
    })
  ]

  depends_on = [
    helm_release.aws_lb_controller
  ]
}

resource "helm_release" "gateway" {
  name      = "gateway-resources"
  namespace = kubernetes_namespace.api_gateway_namespace.metadata[0].name
  chart     = "${path.module}/charts/api-gateway"

  depends_on = [
    helm_release.contour
  ]
}

resource "helm_release" "flagger" {
  name       = "flagger"
  namespace  = kubernetes_namespace.api_gateway_namespace.metadata[0].name
  repository = "https://flagger.app"
  chart      = "flagger"
  version    = var.flagger_version

  set = [
    {
      name  = "meshProvider"
      value = "gatewayapi:v1"
    },
    {
      name  = "prometheus.install"
      value = "true"
    }
  ]
}

resource "helm_release" "loadtester" {
  name       = "loadtester"
  namespace  = kubernetes_namespace.api_gateway_namespace.metadata[0].name
  repository = "https://flagger.app"
  chart      = "loadtester"
  version    = var.loadtester_version
}
