Developer
    │
    ▼
Docker Build
    │
    ▼
Azure Container Registry
    │
    │ image pull
    ▼
AKS
    │
    ▼
Kubernetes Pod




check-----------
docker build
      ↓
docker tag
      ↓
az acr login
      ↓
docker push
      ↓
ACR
      ↓
AKS pulls image
      ↓
Pod starts
