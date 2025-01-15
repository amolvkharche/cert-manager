helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.1/cert-manager.yaml

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace

kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller  --timeout=60s

kubectl apply -f clusterissuer.yaml

kubectl apply -f certificate.yaml

kubectl apply -f ingress.yaml
