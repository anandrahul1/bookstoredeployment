# Kubernetes Deployment Guide

This directory contains all the Kubernetes manifests for deploying the Online Bookstore microservices to Amazon EKS.

## Quick Start

1. **Make the deployment script executable:**
   ```bash
   chmod +x deploy.sh
   ```

2. **Run the deployment:**
   ```bash
   ./deploy.sh
   ```

## Manual Deployment

If you prefer to deploy manually, follow these steps in order:

### 1. Create Namespace
```bash
kubectl apply -f namespace.yaml
```

### 2. Create Service Account and RBAC
```bash
kubectl apply -f serviceaccount.yaml
```

### 3. Create ConfigMaps
```bash
kubectl apply -f configmaps/
```

### 4. Create Secrets
```bash
kubectl apply -f secrets/
```

### 5. Create Services
```bash
kubectl apply -f services/
```

### 6. Create Deployments
```bash
kubectl apply -f deployments/
```

### 7. Create Ingress
```bash
kubectl apply -f ingress/
```

## Verification

Check the deployment status:

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

## Configuration Notes

### Service Account
- The `chatbot-service-sa` service account is configured with IAM role for Bedrock access
- Update the role ARN in `serviceaccount.yaml` before deployment

### ConfigMaps
- `aws-config.yaml`: Contains AWS service configuration (Cognito, Bedrock)
- `database-config.yaml`: Contains RDS connection details

### Secrets
- `database-secret.yaml`: Contains base64-encoded database credentials
- Update with your actual database password before deployment

### Ingress
- Configured for AWS Load Balancer Controller
- Update the certificate ARN and hostname before deployment
- Routes traffic to appropriate services based on path

## Troubleshooting

### Common Issues

1. **Pods in CrashLoopBackOff:**
   ```bash
   kubectl logs -n bookstore <pod-name>
   ```

2. **Database Connection Issues:**
   - Verify RDS endpoint in `database-config.yaml`
   - Check database credentials in `database-secret.yaml`
   - Ensure security groups allow traffic from EKS

3. **Load Balancer Not Created:**
   - Verify AWS Load Balancer Controller is installed
   - Check ingress annotations
   - Verify IAM permissions

### Scaling

Scale individual services:
```bash
kubectl scale deployment catalog-service --replicas=3 -n bookstore
```

Scale all services:
```bash
kubectl scale deployment --all --replicas=2 -n bookstore
```

## Resource Requirements

Each service is configured with:
- **Requests:** 250m CPU, 256Mi memory
- **Limits:** 500m CPU, 512Mi memory

Adjust based on your workload requirements.