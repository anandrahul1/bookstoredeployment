#!/bin/bash

# Deploy infrastructure with Terraform
set -e

echo "Deploying AWS infrastructure with Terraform..."

# Check if we're in the right directory
if [ ! -f "main.tf" ]; then
    echo "Error: main.tf not found. Please run this script from the terraform/environments/poc directory."
    exit 1
fi

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Validate configuration
echo "Validating Terraform configuration..."
terraform validate

# Plan deployment
echo "Planning deployment..."
terraform plan -out=tfplan

# Ask for confirmation
read -p "Do you want to apply this plan? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Deployment cancelled."
    exit 0
fi

# Apply the plan
echo "Applying Terraform configuration..."
terraform apply tfplan

# Clean up plan file
rm -f tfplan

echo "Infrastructure deployment complete!"
echo ""
echo "Next steps:"
echo "1. Configure kubectl:"
echo "   aws eks update-kubeconfig --region us-east-1 --name online-bookstore-poc-cluster"
echo ""
echo "2. Install AWS Load Balancer Controller:"
echo "   kubectl apply -k 'github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master'"
echo ""
echo "3. Deploy the application:"
echo "   cd ../../../k8s && ./deploy.sh"
echo ""
echo "To get outputs:"
echo "   terraform output"