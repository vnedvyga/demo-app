output "apigw_lb" {
  value = data.aws_lb.apigw_lb.arn
  description = "AWS LB (NLB) arn created by contour api gateway"
}

output "aws_region" {
  value = var.aws_region
  description = "AWS region of provisioned LB (NLB)"
}
