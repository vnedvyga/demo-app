include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Read common eks settings
include "eks_common" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_common/eks.hcl"
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/eks/aws?version=21.9.0"
}
