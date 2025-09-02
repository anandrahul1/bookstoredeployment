# Terraform Infrastructure

This directory contains the Terraform configuration for deploying the AWS infrastructure required for the Online Bookstore microservices application.

## Architecture

The infrastructure includes:
- **VPC** with public and private subnets across 2 AZs
- **EKS Cluster** for container orchestration
- **RDS MySQL** database for application data
- **Amazon Cognito** for user authentication
- **Amazon Bedrock** for AI/ML capabilities
- **ECR repositories** for container images
- **IAM roles and policies** for service permissions

## Quick Start

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured with appropriate permissions
- kubectl installed

### Deployment

1. **Navigate to the POC environment:**
   ```bash
   cd environments/poc
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Review the plan:**
   ```bash
   terraform plan
   ```

4. **Apply the configuration:**
   ```bash
   terraform apply
   ```

5. **Configure kubectl:**
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name online-bookstore-poc-cluster
   ```

## Configuration

### Environment Variables
The POC environment is configured in `terraform.tfvars` with cost-optimized settings:
- **EKS**: t3.medium nodes, 2-3 node capacity
- **RDS**: db.t3.micro instance, 20GB storage
- **VPC**: 10.0.0.0/16 CIDR across 2 AZs

### Customization
Modify `terraform.tfvars` to adjust:
- Instance sizes
- Node capacity
- Database configuration
- Network settings

## Outputs

After deployment, Terraform provides:
- EKS cluster endpoint and certificate
- RDS endpoint and connection details
- Cognito user pool and client IDs
- VPC and subnet information

## Cost Optimization

This configuration is optimized for POC/development:
- Minimal instance sizes
- Single AZ RDS (no Multi-AZ)
- Spot instances where applicable
- Auto-scaling for cost efficiency

## Cleanup

To destroy the infrastructure:
```bash
terraform destroy
```

**Warning:** This will delete all resources and data. Ensure you have backups if needed.

## Troubleshooting

### Common Issues

1. **Permission Errors:**
   - Ensure AWS credentials have sufficient permissions
   - Check IAM policies for EKS, RDS, and VPC operations

2. **Resource Limits:**
   - Verify AWS service quotas in your region
   - Check EIP limits for NAT gateways

3. **State Issues:**
   - Use `terraform refresh` to sync state
   - Consider remote state backend for team collaboration

## Security

- All resources are deployed in private subnets where possible
- Security groups restrict access to necessary ports only
- IAM roles follow least-privilege principle
- Database credentials are managed via AWS Secrets Manager