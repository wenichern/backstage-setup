variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "${{ values.project_name }}"
}

variable "environment" {
  description = "Environment (dev, staging, production)"
  type        = string
  default     = "${{ values.environment }}"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "${{ values.aws_region }}"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "${{ values.vpc_cidr }}"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "${{ values.instance_type }}"
}

variable "application_port" {
  description = "Port the application listens on"
  type        = number
  default     = ${{ values.application_port }}
}

variable "enable_kubernetes" {
  description = "Enable EKS cluster"
  type        = bool
  default     = ${{ values.enable_kubernetes }}
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 access"
  type        = string
  sensitive   = true
}
