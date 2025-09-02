# POC Environment Main Configuration
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
  

}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# Use the root module
module "infrastructure" {
  source = "../../"
  
  # Pass all variables to the root module
  project_name                = var.project_name
  environment                 = var.environment
  aws_region                  = var.aws_region
  vpc_cidr                    = var.vpc_cidr
  availability_zones          = var.availability_zones
  eks_cluster_version         = var.eks_cluster_version
  eks_node_instance_types     = var.eks_node_instance_types
  eks_node_desired_capacity   = var.eks_node_desired_capacity
  eks_node_max_capacity       = var.eks_node_max_capacity
  eks_node_min_capacity       = var.eks_node_min_capacity
  rds_instance_class          = var.rds_instance_class
  rds_allocated_storage       = var.rds_allocated_storage
  rds_engine_version          = var.rds_engine_version
  rds_database_name           = var.rds_database_name
  rds_username                = var.rds_username
  cognito_user_pool_name      = var.cognito_user_pool_name
  cognito_app_client_name     = var.cognito_app_client_name
  additional_tags             = var.additional_tags
}