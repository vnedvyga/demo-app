include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr://registry.terraform.io/terraform-aws-modules/global-accelerator/aws?version=3.0.0"
}

dependency "central_endpoint" {
  config_path = "../../eu-central-1/kubernetes"
}

dependency "west_endpoint" {
  config_path = "../../eu-west-2/kubernetes"
}

locals {
  # Read environment-specific variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  env      = local.env_vars.locals.env
}

inputs = {
  name = "demo-app"

  listeners = {
    listener_main = {
      client_affinity = "SOURCE_IP"

      endpoint_groups = {
        my_group = {
          health_check_port             = 80
          health_check_protocol         = "HTTP"
          health_check_path             = "/"
          health_check_interval_seconds = 10
          health_check_timeout_seconds  = 5
          healthy_threshold_count       = 2
          unhealthy_threshold_count     = 2
          traffic_dial_percentage       = 100

          endpoint_configuration = [{
            client_ip_preservation_enabled = true
            endpoint_id                    = dependency.central_endpoint.outputs.apigw_lb
            weight                         = 128
          }, {
            client_ip_preservation_enabled = true
            endpoint_id                    = dependency.west_endpoint.outputs.apigw_lb
            weight                         = 128
          }]
        }
      }
      port_ranges = [
        {
          from_port = 80
          to_port   = 80
        }
      ]
      protocol = "TCP"
    }
  }

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}
