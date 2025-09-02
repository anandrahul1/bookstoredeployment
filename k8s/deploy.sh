#!/bin/bash

# Deploy Online Bookstore to EKS
set -e

echo "Deploying Online Bookstore to EKS..."

# Create namespace
echo "Creating namespace..."
kubectl apply -f namespace.yaml

# Create service account and RBAC
echo "Creating service account and RBAC..."
kubectl apply -f serviceaccount.yaml

# Create ConfigMaps
echo "Creating ConfigMaps..."
kubectl apply -f configmaps/

# Create Secrets
echo "Creating Secrets..."
kubectl apply -f secrets/

# Create Services
echo "Creating Services..."
kubectl apply -f services/

# Create Deployments
echo "Creating Deployments..."
kubectl apply -f deployments/

# Create Ingress
echo "Creating Ingress..."
kubectl apply -f ingress/

echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment --all -n bookstore

echo "Deployment complete!"
echo "Getting service status..."
kubectl get pods -n bookstore
kubectl get services -n bookstore
kubectl get ingress -n bookstore

echo "To get the load balancer URL, run:"
echo "kubectl get ingress bookstore-ingress -n bookstore -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'"