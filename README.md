# Telecom OSS/BSS Platform on Microsoft Azure

A cloud-native Telecom OSS/BSS application platform built on Microsoft Azure using Terraform, Azure Kubernetes Service (AKS), Azure Container Registry (ACR), Docker, Kubernetes, Java Spring Boot, Maven, and Azure DevOps CI/CD.

The project demonstrates how a telecom-oriented microservices application can be containerized, provisioned using Infrastructure as Code, deployed to Kubernetes, exposed through an ingress layer, and automated using CI/CD.

---

## Architecture Overview

```text
                         ┌──────────────────────────┐
                         │        Developer         │
                         │ Git / Pull Request       │
                         └────────────┬─────────────┘
                                      │
                                      ▼
                         ┌──────────────────────────┐
                         │     Azure DevOps         │
                         │      CI/CD Pipeline      │
                         └────────────┬─────────────┘
                                      │
                    ┌─────────────────┴─────────────────┐
                    │                                   │
                    ▼                                   ▼
             Maven Build/Test                    Docker Build
                    │                                   │
                    └─────────────────┬─────────────────┘
                                      │
                                      ▼
                         ┌──────────────────────────┐
                         │ Azure Container Registry │
                         │          ACR             │
                         └────────────┬─────────────┘
                                      │
                                      ▼
                         ┌──────────────────────────┐
                         │ Azure Kubernetes Service │
                         │          AKS             │
                         └────────────┬─────────────┘
                                      │
                         ┌────────────┴────────────┐
                         │                         │
                         ▼                         ▼
                  Kubernetes Ingress          Kubernetes Services
                         │                         │
             ┌───────────┼────────────┬────────────┘
             │           │            │
             ▼           ▼            ▼
          Billing       CDR        Customer
          Service      Service      Service
```

---

## Project Objective

The objective of this project is to demonstrate an end-to-end Azure DevOps and cloud-native deployment workflow for a Telecom OSS/BSS application.

The project covers:

* Microservices development
* Java Spring Boot
* Maven
* Docker
* Kubernetes
* Azure Kubernetes Service
* Azure Container Registry
* Terraform Infrastructure as Code
* Azure networking
* Kubernetes ingress
* CI/CD with Azure Pipelines
* Application deployment
* Troubleshooting and operational validation

---

## Application Components

### Billing Service

Responsible for telecom billing-related operations.

Technology:

* Java
* Spring Boot
* Maven
* Docker
* Kubernetes

### CDR Service

Responsible for handling Call Detail Record related functionality.

### Customer Service

Responsible for customer-related operations.

---

## Azure Infrastructure

The infrastructure is provisioned using Terraform.

Major Azure resources include:

* Resource Group
* Azure Virtual Network
* AKS
* Azure Container Registry
* Log Analytics / Container Insights
* AKS networking components

Terraform configuration is located under:

```text
terraform/
```

---

## Kubernetes Architecture

Kubernetes manifests are stored under:

```text
k8s/
```

The deployment includes:

* Namespace
* ConfigMap
* Secret
* Deployments
* ClusterIP Services
* Ingress

The application services run inside the Kubernetes namespace:

```text
telecom
```

---

## CI/CD Pipeline

The project uses Azure Pipelines.

The pipeline performs the following high-level workflow:

```text
Git Push
   │
   ▼
Build
   │
   ├── Java 17
   ├── Maven
   └── Unit Tests
   │
   ▼
Docker Build
   │
   ├── Billing Image
   ├── CDR Image
   └── Customer Image
   │
   ▼
Azure Container Registry
   │
   ▼
AKS Deployment
   │
   ▼
Kubernetes Verification
```

The pipeline is defined in:

```text
azure-pipelines.yml
```

The current pipeline contains a build/test stage and a Docker image build/push stage, with deployment/verification logic also defined in the pipeline.

---

## Repository Structure

```text
telecom-ossbss-azure/
│
├── docs/
│
├── src/
│   ├── billing-service/
│   ├── cdr-service/
│   └── customer-service/
│
├── k8s/
│   ├── namespace.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── billing-deployment.yaml
│   ├── billing-service.yaml
│   ├── cdr-deployment.yaml
│   ├── cdr-service.yaml
│   ├── customer-deployment.yaml
│   ├── customer-service.yaml
│   └── ingress.yaml
│
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── .terraform.lock.hcl
│
├── azure-pipelines.yml
├── pom.xml
└── .gitignore
```

---

# Deployment Flow

## Step 1 — Clone Repository

```bash
git clone https://github.com/paritoshpthk-creator/telecom-ossbss-azure.git
cd telecom-ossbss-azure
```

## Step 2 — Build Application

```bash
mvn clean test package
```

## Step 3 — Build Docker Images

```bash
docker build -t billing-service ./src/billing-service
docker build -t cdr-service ./src/cdr-service
docker build -t customer-service ./src/customer-service
```

## Step 4 — Provision Azure Infrastructure

```bash
cd terraform

terraform init
terraform validate
terraform plan
terraform apply
```

## Step 5 — Connect to AKS

```bash
az aks get-credentials \
  --resource-group <RESOURCE_GROUP> \
  --name <AKS_CLUSTER>
```

Verify:

```bash
kubectl get nodes
```

## Step 6 — Deploy Kubernetes Resources

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml

kubectl apply -f k8s/
```

Verify:

```bash
kubectl get pods -n telecom
kubectl get svc -n telecom
kubectl get ingress -n telecom
```

---

# Validation

Check application health:

```bash
kubectl get pods -n telecom
```

Check services:

```bash
kubectl get svc -n telecom
```

Check ingress:

```bash
kubectl get ingress -n telecom
```

Check logs:

```bash
kubectl logs -n telecom <POD_NAME>
```

Describe resources when troubleshooting:

```bash
kubectl describe pod -n telecom <POD_NAME>
```

---

# Troubleshooting

Detailed troubleshooting documentation is available under:

```text
docs/troubleshooting/
```

Common problems covered include:

* Terraform provider errors
* Resource group problems
* Azure SKU restrictions
* Azure vCPU quota problems
* AKS provisioning failures
* ACR authentication
* Docker build failures
* Maven/Java problems
* Kubernetes ImagePullBackOff
* CrashLoopBackOff
* Service connectivity
* Ingress routing
* DNS/hosts-file problems
* Azure Pipeline failures
* Azure DevOps hosted-agent limitations

---

# Lessons Learned

This project provided practical experience with:

1. Infrastructure as Code using Terraform
2. Azure resource provisioning
3. AKS administration
4. Kubernetes deployments and services
5. Docker containerization
6. ACR image management
7. CI/CD pipeline implementation
8. Application troubleshooting
9. Kubernetes networking
10. Azure quota and SKU troubleshooting
11. Production-style operational documentation

---

# Future Improvements

Potential future improvements:

* Azure Key Vault integration
* Managed Identity
* Private AKS cluster
* Azure Application Gateway
* Azure Front Door
* Azure Monitor
* Managed Prometheus
* Managed Grafana
* Horizontal Pod Autoscaler
* Cluster Autoscaler
* Network Policies
* GitOps with Argo CD
* Helm charts
* Terraform remote state in Azure Storage
* Environment separation for dev/test/prod
* Security scanning
* Container image vulnerability scanning
* Blue/green or canary deployments

---

## Author

Paritosh Pathak

Azure | DevOps | Kubernetes | Terraform | Cloud Engineering
