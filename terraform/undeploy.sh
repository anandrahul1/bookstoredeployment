#!/bin/bash

# Destroy infrastructure with Terraform
set -e

echo "WARNING: This will destroy ALL AWS infrastructure!"
echo "This action cannot be undone and will delete:"
echo "- EKS cluster and all workloads"
echo "- RDS database and all data"
echo "- VPC and networking components"
echo "- All other AWS resources"
echo ""

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo "Error: main.tf not found. Please run this script from the terraform/environments/poc directory."
    exit 1
fi

# Double confirmation
read -p "Are you absolutely sure you want to destroy all infrastructure? Type 'destroy' to confirm: " confirm
if [ "$confirm" != "destroy" ]; then
    echo "Destruction cancelled."
    exit 0
fi

echo "Destroying AWS infrastructure..."

# Plan destruction
echo "Planning destruction..."
terraform plan -destroy -out=destroy-plan

# Final confirmation
read -p "Review the destroy plan above. Type 'yes' to proceed: " final_confirm
if [ "$final_confirm" != "yes" ]; then
    echo "Destruction cancelled."
    rm -f destroy-plan
    exit 0
fi

# Apply destruction
echo "Applying destruction plan..."
terraform apply destroy-plan

# Clean up
rm -f destroy-plan

echo "Infrastructure destruction complete!"
echo "All AWS resources have been deleted."