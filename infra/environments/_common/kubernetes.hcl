locals {
  # Read region-specific variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region  = local.region_vars.locals.aws_region
}

dependency "eks" {
  config_path = "../eks"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  aws_region        = local.aws_region
  aws_vpc_id        = dependency.vpc.outputs.vpc_id

  github_org        = "vnedvyga"
  github_repository = "demo-app"
  gitops_path       = "deploy/clusters/${local.aws_region}"
  github_token      = get_env("GITHUB_TOKEN")

  cluster_endpoint = dependency.eks.outputs.cluster_endpoint
  cluster_ca_cert  = dependency.eks.outputs.cluster_certificate_authority_data
  cluster_name     = dependency.eks.outputs.cluster_name
}


