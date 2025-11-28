locals {
    region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
    aws_region  = local.region_vars.locals.aws_region
}

remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "vn-synth-demo-tf-state-${local.aws_region}"
    key            = "${path_relative_to_include()}/tf.tfstate"
    region         = local.aws_region
    use_lockfile   = true
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "skip"
  contents = <<EOF
provider "aws" {
  region = "${local.aws_region}"
}
EOF
}
