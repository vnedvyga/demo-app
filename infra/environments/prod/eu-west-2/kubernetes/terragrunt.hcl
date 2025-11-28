include "root" {
  path = find_in_parent_folders("root.hcl")
}

# Read common kubernetes settings
include "kubernetes_common" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_common/kubernetes.hcl"
}

terraform {
  source = "../../../../modules/kubernetes"
}
