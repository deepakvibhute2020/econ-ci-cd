output "cluster_name" { value = module.eks.cluster_name }
output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "cluster_version" { value = module.eks.cluster_version }
output "vpc_id" { value = module.vpc.vpc_id }
output "private_subnet_ids" { value = module.vpc.private_subnets }
output "managed_node_group_names" { value = keys(module.eks.eks_managed_node_groups) }
output "ecr_repository_urls" {
  description = "ECR repository URLs for application services"

  value = {
    for name, repository in aws_ecr_repository.services :
    name => repository.repository_url
  }
}
