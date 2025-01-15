helm repo add jetstack https://charts.jetstack.io
helm repo update

kubectl create namespace cert-manager
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.13.1 \
  --set installCRDs=true

kubectl apply -f clusterissuer.yaml

kubectl apply -f certificate.yaml

kubectl apply -f ingress.yaml
