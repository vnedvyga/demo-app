data "aws_lb" "apigw_lb" {
  tags = {
    "service.k8s.aws/stack" = "${var.api_gateway_namespace}/${var.api_gateway_name}-envoy"
  }
  depends_on = [helm_release.contour]
}
