# POC Environment Configuration
project_name = "online-bookstore"
environment  = "poc"
aws_region   = "us-east-1"

# VPC Configuration - Minimal for POC
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]

# EKS Configuration - Minimal for POC
eks_cluster_version      = "1.28"
eks_node_instance_types  = ["t3.medium"]
eks_node_desired_capacity = 2
eks_node_max_capacity     = 3
eks_node_min_capacity     = 1

# RDS Configuration - Minimal for POC
rds_instance_class    = "db.t3.micro"
rds_allocated_storage = 20
rds_engine_version    = "8.0"
rds_database_name     = "bookstore"
rds_username          = "admin"

# Cognito Configuration
cognito_user_pool_name  = "bookstore-users"
cognito_app_client_name = "bookstore-app"

# Additional Tags
additional_tags = {
  Owner       = "DevTeam"
  Purpose     = "POC"
  CostCenter  = "Engineering"
  AutoShutdown = "true"
}