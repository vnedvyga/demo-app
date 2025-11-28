include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Read common vpc settings
include "vpc_common" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_common/vpc.hcl"
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/vpc/aws?version=6.5.1"
}
