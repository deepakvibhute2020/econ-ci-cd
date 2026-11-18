locals {
  ecr_repositories = [
    "ecom-gateway-service-ecr",
    "ecom-masterdata-service-ecr",
    "ecom-userauth-service-ecr"
  ]
}

resource "aws_ecr_repository" "services" {
  for_each = toset(local.ecr_repositories)

  name                 = each.value
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Environment = var.environment
    Project     = "ECON ecommerce"
    ManagedBy   = "Terraform"
  }
}