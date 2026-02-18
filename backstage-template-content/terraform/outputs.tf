output "project_name" {
  description = "Project name"
  value       = var.project_name
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.app.id
}

output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = aws_instance.app.public_ip
}

output "instance_private_ip" {
  description = "Private IP of EC2 instance"
  value       = aws_instance.app.private_ip
}

output "security_group_id" {
  description = "Security group ID"
  value       = aws_security_group.instance.id
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = var.enable_kubernetes ? aws_eks_cluster.main[0].endpoint : null
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = var.enable_kubernetes ? aws_eks_cluster.main[0].name : null
}

output "application_url" {
  description = "Application URL"
  value       = "http://${aws_instance.app.public_ip}:${var.application_port}"
}

output "ssh_command" {
  description = "SSH command to connect to instance"
  value       = "ssh -i ~/.ssh/${var.project_name}-key.pem ec2-user@${aws_instance.app.public_ip}"
}
