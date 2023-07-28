# Update VM
apt update && apt upgrade -y

# Install K3s
curl -sfL https://get.k3s.io | sh -

## Check for Ready node, takes ~30 seconds 
kubectl get node 

# Install Argo Workflows
kubectl create namespace argo
kubectl apply -n argo -f ./argo-workflows.yaml

## Patch authentication
kubectl patch deployment \
  argo-server \
  --namespace argo \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/args", "value": [
  "server",
  "--auth-mode=server"
]}]'

# Install MinIO
kubectl apply -f minio.yaml

## Verify MinIO is running
kubectl get pods -n minio