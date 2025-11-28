locals {
  # Read region-specific variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  aws_region  = local.region_vars.locals.aws_region

  # Read environment-specific variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  env      = local.env_vars.locals.env
}

inputs = {
  name = "demo-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.aws_region}a", "${local.aws_region}b", "${local.aws_region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Environment = local.env
    Terraform = "true"
  }
}
