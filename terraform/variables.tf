variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "test"
}

variable "cluster_name" {
  type    = string
  default = "econ-test-eks"
}

variable "kubernetes_version" {
  description = "EKS Kubernetes minor version. Confirm regional availability before applying."
  type        = string
  default     = "1.37"
}

variable "vpc_cidr" {
  type    = string
  default = "10.40.0.0/16"
}

variable "node_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "node_disk_size" {
  type    = number
  default = 30
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_desired_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 2
}

variable "github_actions_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions; granted EKS cluster-admin access in this starter configuration."
  type        = string
}
