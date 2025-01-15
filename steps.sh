helm repo add jetstack https://charts.jetstack.io
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

kubectl create namespace cert-manager
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version v1.13.1 \
  --set installCRDs=true

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace

kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller  --timeout=60s

kubectl apply -f clusterissuer.yaml

kubectl apply -f certificate.yaml

kubectl apply -f ingress.yaml
