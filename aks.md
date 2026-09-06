# AKS Troubleshooting

## Check cluster

az aks show \
  --resource-group <RG> \
  --name <AKS>

## Get credentials

az aks get-credentials \
  --resource-group <RG> \
  --name <AKS>

## Check nodes

kubectl get nodes -o wide

## Check pods

kubectl get pods -n telecom -o wide

## Check services

kubectl get svc -n telecom

## Check ingress

kubectl get ingress -n telecom

## Pod troubleshooting

kubectl describe pod <pod> -n telecom

kubectl logs <pod> -n telecom

## ImagePullBackOff

Check:

1. Image name
2. Image tag
3. ACR login
4. AKS → ACR permissions
5. Image existence

## CrashLoopBackOff

Check:

kubectl logs
kubectl describe pod
kubectl get events
