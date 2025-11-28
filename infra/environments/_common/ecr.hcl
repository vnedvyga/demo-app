locals {
  # Read environment-specific variables
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
  env      = local.env_vars.locals.env
}

inputs = {
  repository_name = "demo-app"

  repository_read_write_access_arns = ["arn:aws:iam::488639172435:role/githubworker"]
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 3 images",
        selection = {
          tagStatus     = "tagged",
          tagPatternList = ["*"],
          countType     = "imageCountMoreThan",
          countNumber   = 3
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}