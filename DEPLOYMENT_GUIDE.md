# Complete Deployment Guide

This guide walks you through deploying the Online Bookstore microservices application to AWS using EKS.

## Prerequisites

Before starting, ensure you have:

- **AWS CLI** configured with appropriate permissions
- **kubectl** installed and configured
- **Terraform** >= 1.0 installed
- **Docker** installed (for building images)
- **Git** for cloning repositories

### Required AWS Permissions

Your AWS user/role needs permissions for:
- EKS (cluster management)
- EC2 (VPC, security groups, instances)
- RDS (database creation)
- IAM (role creation)
- Cognito (user pool management)
- Bedrock (AI services)
- ECR (container registry)
- Secrets Manager (credential storage)

## Step-by-Step Deployment

### 1. Clone the Repository

```bash
git clone https://github.com/anandrahul1/bookstoredeployment.git
cd bookstoredeployment
```

### 2. Deploy Infrastructure

```bash
cd terraform/environments/poc

# Make deployment script executable
chmod +x ../deploy.sh

# Deploy infrastructure
../deploy.sh
```

This will create:
- VPC with public/private subnets
- EKS cluster with worker nodes
- RDS MySQL database
- Cognito user pool
- ECR repositories
- IAM roles and policies

### 3. Configure kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name online-bookstore-poc-cluster
```

### 4. Install AWS Load Balancer Controller

```bash
# Install CRDs
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller//crds?ref=master"

# Install controller (replace with your cluster name and region)
helm repo add eks https://aws.github.io/eks-charts
helm repo update
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=online-bookstore-poc-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller
```

### 5. Update Configuration Files

Before deploying the application, update these files with your actual values:

#### k8s/serviceaccount.yaml
```yaml
# Replace REPLACE_WITH_BEDROCK_IAM_ROLE_ARN with actual role ARN
annotations:
  eks.amazonaws.com/role-arn: "arn:aws:iam::YOUR_ACCOUNT:role/bedrock-service-role"
```

#### k8s/ingress/bookstore-ingress.yaml
```yaml
# Replace with your ACM certificate ARN and domain
alb.ingress.kubernetes.io/certificate-arn: "arn:aws:acm:us-east-1:YOUR_ACCOUNT:certificate/YOUR_CERT_ID"
# Replace with your domain
host: your-domain.com
```

#### k8s/secrets/database-secret.yaml
```bash
# Update with your actual database password (base64 encoded)
echo -n "your-actual-password" | base64
```

### 6. Deploy Application

```bash
cd ../../../k8s

# Make deployment script executable
chmod +x deploy.sh

# Deploy application
./deploy.sh
```

### 7. Verify Deployment

```bash
# Check pods
kubectl get pods -n bookstore

# Check services
kubectl get svc -n bookstore

# Check ingress
kubectl get ingress -n bookstore

# Get load balancer URL
kubectl get ingress bookstore-ingress -n bookstore -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

## Post-Deployment Configuration

### 1. DNS Configuration

Point your domain to the ALB hostname:
```bash
# Get ALB hostname
ALB_HOSTNAME=$(kubectl get ingress bookstore-ingress -n bookstore -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "Point your domain to: $ALB_HOSTNAME"
```

### 2. SSL Certificate

Ensure your ACM certificate covers your domain and is validated.

### 3. Database Initialization

The application will automatically run database migrations on startup.

## Monitoring and Troubleshooting

### Check Application Health

```bash
# Check all pods
kubectl get pods -n bookstore

# Check specific service logs
kubectl logs -n bookstore -l app=catalog-service

# Check ingress status
kubectl describe ingress bookstore-ingress -n bookstore
```

### Common Issues

1. **Pods in CrashLoopBackOff:**
   ```bash
   kubectl logs -n bookstore <pod-name>
   kubectl describe pod -n bookstore <pod-name>
   ```

2. **Database Connection Issues:**
   - Verify RDS endpoint in ConfigMap
   - Check security groups allow EKS to RDS traffic
   - Verify database credentials

3. **Load Balancer Not Created:**
   - Check AWS Load Balancer Controller logs
   - Verify IAM permissions
   - Check ingress annotations

### Scaling

Scale services based on load:
```bash
# Scale specific service
kubectl scale deployment catalog-service --replicas=3 -n bookstore

# Scale all services
kubectl scale deployment --all --replicas=2 -n bookstore
```

## Cost Optimization

This deployment is configured for cost optimization:

- **EKS**: t3.medium nodes with auto-scaling
- **RDS**: db.t3.micro instance (upgrade for production)
- **Single AZ**: For development (use Multi-AZ for production)
- **Spot Instances**: Where applicable

### Estimated Monthly Costs (us-east-1)

- EKS Cluster: ~$73/month
- EC2 Instances (2x t3.medium): ~$60/month
- RDS (db.t3.micro): ~$15/month
- Load Balancer: ~$20/month
- **Total**: ~$170/month

## Security Considerations

- All application traffic flows through private subnets
- Database is not publicly accessible
- IAM roles follow least-privilege principle
- Secrets are stored in Kubernetes secrets (consider AWS Secrets Manager for production)

## Cleanup

To destroy all resources:

```bash
# Delete Kubernetes resources first
kubectl delete namespace bookstore

# Destroy infrastructure
cd terraform/environments/poc
chmod +x ../undeploy.sh
../undeploy.sh
```

**Warning**: This will delete all data permanently.

## Support

For issues:
1. Check the troubleshooting section above
2. Review AWS CloudWatch logs
3. Check EKS cluster events
4. Verify security group configurations

## Next Steps

For production deployment:
1. Use Multi-AZ RDS deployment
2. Implement proper backup strategies
3. Set up monitoring with CloudWatch/Prometheus
4. Configure auto-scaling policies
5. Implement CI/CD pipelines
6. Use AWS Secrets Manager for sensitive data