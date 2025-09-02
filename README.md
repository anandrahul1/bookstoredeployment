# Online Bookstore Microservices - AWS Deployment

This repository contains all the AWS deployment manifests and infrastructure code for the Online Bookstore microservices application.

## Architecture Overview

The application consists of 7 microservices deployed on Amazon EKS:
- **UI Service** - Frontend web interface
- **User Service** - User management and authentication
- **Catalog Service** - Book catalog management
- **Cart Service** - Shopping cart functionality
- **Order Service** - Order processing
- **Payment Service** - Payment processing
- **Chatbot Service** - AI-powered customer support

## Infrastructure Components

### AWS Services Used
- **Amazon EKS** - Kubernetes cluster for container orchestration
- **Amazon RDS (MySQL)** - Database for application data
- **Amazon Cognito** - User authentication and authorization
- **Amazon Bedrock** - AI/ML services for chatbot functionality
- **Amazon ECR** - Container registry for Docker images
- **AWS Load Balancer Controller** - Ingress and load balancing
- **Amazon VPC** - Network isolation and security

### Repository Structure

```
├── terraform/                 # Infrastructure as Code
│   ├── environments/poc/      # POC environment configuration
│   └── modules/              # Reusable Terraform modules
├── k8s/                      # Kubernetes manifests
│   ├── deployments/          # Service deployments
│   ├── services/             # Kubernetes services
│   ├── configmaps/           # Configuration data
│   ├── secrets/              # Sensitive data
│   └── ingress/              # Load balancer configuration
├── aws-config/               # AWS service configuration scripts
└── cicd/                     # CI/CD pipeline configuration
```

## Deployment Instructions

### Prerequisites
- AWS CLI configured with appropriate permissions
- kubectl configured to access your EKS cluster
- Terraform installed
- Docker installed (for building images)

### 1. Infrastructure Deployment

```bash
# Deploy infrastructure with Terraform
cd terraform/environments/poc
terraform init
terraform plan
terraform apply
```

### 2. Kubernetes Deployment

```bash
# Deploy to EKS cluster
cd k8s
kubectl apply -f namespace.yaml
kubectl apply -f secrets/
kubectl apply -f configmaps/
kubectl apply -f serviceaccount.yaml
kubectl apply -f deployments/
kubectl apply -f services/
kubectl apply -f ingress/
```

### 3. Verify Deployment

```bash
# Check pod status
kubectl get pods -n bookstore

# Check services
kubectl get svc -n bookstore

# Check ingress
kubectl get ingress -n bookstore
```

## Configuration

### Environment Variables
The application uses the following key environment variables:
- `NODE_ENV=production`
- `DB_HOST` - RDS endpoint
- `DB_PORT` - Database port (3306 for MySQL)
- `DB_NAME` - Database name
- `DB_USER` - Database username
- `DB_PASSWORD` - Database password (stored in Kubernetes secret)
- `AWS_REGION` - AWS region

### Database Configuration
- **Engine**: MySQL 8.0
- **Instance Class**: db.t3.micro (for POC)
- **Storage**: 20GB GP2
- **Multi-AZ**: Disabled (for cost optimization in POC)

### Security
- All sensitive data stored in Kubernetes secrets
- Database credentials managed via AWS Secrets Manager
- Network isolation using VPC and security groups
- RBAC configured for service accounts

## Monitoring and Troubleshooting

### Health Checks
Each service exposes a `/health` endpoint for health monitoring.

### Logs
```bash
# View service logs
kubectl logs -n bookstore -l app=catalog-service

# View all pods in namespace
kubectl get pods -n bookstore
```

### Common Issues
1. **CrashLoopBackOff**: Check logs for database connection issues
2. **ImagePullBackOff**: Verify ECR repository and image tags
3. **Service Unavailable**: Check ingress configuration and load balancer

## Cost Optimization

This deployment is optimized for POC/development use:
- Single AZ deployment
- Minimal instance sizes
- Spot instances where applicable
- Auto-scaling configured for cost efficiency

## Support

For issues and questions:
1. Check the troubleshooting section above
2. Review pod logs using kubectl
3. Verify AWS resource status in the console

## License

This project is licensed under the MIT License - see the LICENSE file for details.