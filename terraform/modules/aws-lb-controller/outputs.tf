output "alb_controller_role_arn" {
  description = "ARN of the IAM role for AWS Load Balancer Controller"
  value       = aws_iam_role.alb_controller.arn
}

output "alb_controller_policy_arn" {
  description = "ARN of the IAM policy for AWS Load Balancer Controller"
  value       = aws_iam_policy.alb_controller.arn
}

output "alb_controller_service_account" {
  description = "Name of the Kubernetes service account for AWS Load Balancer Controller"
  value       = kubernetes_service_account.alb_controller.metadata[0].name
}

output "helm_release_name" {
  description = "Name of the Helm release for AWS Load Balancer Controller"
  value       = helm_release.alb_controller.name
}

output "helm_release_status" {
  description = "Status of the Helm release for AWS Load Balancer Controller"
  value       = helm_release.alb_controller.status
}
