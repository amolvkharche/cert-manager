#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./steps.sh STACKSTATE_URL"
  exit 1
fi


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.1/cert-manager.yaml

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace

kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller  --timeout=60s


STACKSTATE_URL=$1
export STACKSTATE_URL

kubectl apply -f clusterissuer.yaml

#envsubst < certificate.yaml | kubectl apply -f -
sed "s|\${STACKSTATE_URL}|${STACKSTATE_URL}|g" certificate.yaml | kubectl apply -f -

#envsubst < ingress.yaml | kubectl apply -f -
sed "s|\${STACKSTATE_URL}|${STACKSTATE_URL}|g" ingress.yaml | kubectl apply -f -

