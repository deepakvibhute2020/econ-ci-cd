module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.30.2"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  endpoint_public_access  = true
  endpoint_private_access = true
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    github_actions = {
      principal_arn = var.github_actions_role_arn
      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = { type = "cluster" }
        }
      }
    }
  }

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  eks_managed_node_groups = {
    ecom_gateway = {
      name           = "ecom-gateway-ng"
      instance_types = [var.node_instance_type]
      min_size       = var.node_min_size
      desired_size   = var.node_desired_size
      max_size       = var.node_max_size
      disk_size      = var.node_disk_size
      labels = { workload = "ecom-gateway-service" }
    }
    ecom_masterdata = {
      name           = "ecom-masterdata-ng"
      instance_types = [var.node_instance_type]
      min_size       = var.node_min_size
      desired_size   = var.node_desired_size
      max_size       = var.node_max_size
      disk_size      = var.node_disk_size
      labels = { workload = "ecom-masterdata-service" }
    }
    ecom_userauth = {
      name           = "ecom-userauth-ng"
      instance_types = [var.node_instance_type]
      min_size       = var.node_min_size
      desired_size   = var.node_desired_size
      max_size       = var.node_max_size
      disk_size      = var.node_disk_size
      labels = { workload = "ecom-userauth-service" }
    }
  }

  tags = {
    Environment = var.environment
    Project     = "ECON ecommerce"
  }
}
