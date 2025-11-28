locals {
  # Read environment-specific variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  env      = local.env_vars.locals.env
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  name = "demo-cluster"
  kubernetes_version = "1.33"

  endpoint_public_access = true

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    metrics-server         = {}
    vpc-cni                = {
      before_compute = true
    }
  }

  vpc_id     = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets

  eks_managed_node_groups = {
    system = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 3
    }
  }

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}
