variable "api_gateway_name" {
  type        = string
  default     = "contour"
  description = "API Gateway name"
}

variable "api_gateway_namespace" {
  type        = string
  default     = "projectcontour"
  description = "API Gateway namespace"
}

variable "aws_lb_controller_version" {
  type        = string
  default     = "1.16.0"
  description = "AWS LB controller helm chart version"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_vpc_id" {
  type        = string
  description = "AWS VPC ID of K8s cluster"
}

variable "gitops_path" {
  description = "Git repo path where to bootstrap fluxcd"
  type        = string
}

variable "github_token" {
  type        = string
  description = "GitHub PAT token"
  sensitive   = true
}

variable "github_org" {
  type        = string
  description = "GitHub owner"
}

variable "github_repository" {
  type        = string
  description = "GitHub repository"
}

variable "cluster_endpoint" {
  type        = string
  description = "K8s cluster API endpoint"
}

variable "cluster_ca_cert" {
  type        = string
  description = "K8s cluster CA certificate"
}

variable "cluster_name" {
  type        = string
  description = "K8s cluster name"
}

variable "contour_version" {
  type        = string
  default     = "0.1.0"
  description = "Contour helm chart version"
}

variable "flagger_version" {
  type        = string
  default     = "1.42.0"
  description = "Flagger helm chart version"
}

variable "flux_version" {
  type        = string
  default     = "v2.7.4"
  description = "Flux version"
}

variable "loadtester_version" {
  type        = string
  default     = "0.36.0"
  description = "Flagger loadtester helm chart version"
}
