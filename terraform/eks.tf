module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.30.2"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnets

  endpoint_public_access  = true
  endpoint_private_access = true

  # Explicitly configure both administrator identities.
  enable_cluster_creator_admin_permissions = false

  access_entries = {
    cluster_creator = {
      principal_arn = var.terraform_admin_arn

      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }

    github_actions = {
      principal_arn = var.github_actions_role_arn

      policy_associations = {
        cluster_admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  # Explicitly retain both intended KMS administrators.
  kms_key_administrators = [
    var.terraform_admin_arn,
    var.github_actions_role_arn
  ]

  addons = {
    # Install networking components before creating worker nodes.
    vpc-cni = {
      addon_version  = "v1.22.4-eksbuild.14"
      before_compute = true
    }

    kube-proxy = {
      before_compute = true
    }

    # CoreDNS is intentionally installed after compute is available.
    coredns = {}
  }

  eks_managed_node_groups = {
    ecom_gateway = {
      name            = "ecom-gateway-ng"
      use_name_prefix = false

      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "ON_DEMAND"
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      desired_size   = var.node_desired_size
      max_size       = var.node_max_size
      disk_size      = var.node_disk_size
      labels = {
        workload = "ecom-gateway-service"
      }

      # Limit disruption during later managed-node-group updates.
      update_config = {
        max_unavailable = 1
      }

      # Terraform waits longer for EKS to complete the node-group operation.
      # This does not extend EKS's own 15-minute node-registration health check.
      timeouts = {
        create = "45m"
        update = "2h"
        delete = "45m"
      }
    }

    ecom_masterdata = {
      name            = "ecom-masterdata-ng"
      use_name_prefix = false

      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "ON_DEMAND"
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      desired_size   = var.node_desired_size
      max_size       = var.node_max_size
      disk_size      = var.node_disk_size
      labels = {
        workload = "ecom-masterdata-service"
      }

      # Limit disruption during later managed-node-group updates.
      update_config = {
        max_unavailable = 1
      }

      # Terraform waits longer for EKS to complete the node-group operation.
      # This does not extend EKS's own 15-minute node-registration health check.
      timeouts = {
        create = "45m"
        update = "2h"
        delete = "45m"
      }
    }

    ecom_userauth = {
      name            = "ecom-userauth-ng"
      use_name_prefix = false

      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "ON_DEMAND"
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      desired_size   = var.node_desired_size
      max_size       = var.node_max_size
      disk_size      = var.node_disk_size
      labels = {
        workload = "ecom-userauth-service"
      }

      # Limit disruption during later managed-node-group updates.
      update_config = {
        max_unavailable = 1
      }

      # Terraform waits longer for EKS to complete the node-group operation.
      # This does not extend EKS's own 15-minute node-registration health check.
      timeouts = {
        create = "45m"
        update = "2h"
        delete = "45m"
      }
    }
  }

  tags = {
    Environment = var.environment
    Project     = "ECON ecommerce"
  }
}