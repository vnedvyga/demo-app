include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Read common ecr settings
include "ecr_common" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_common/ecr.hcl"
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/ecr/aws?version=3.1.0"
}
