#!/bin/bash

helm repo add ibb https://ibbproject.github.io/helm-charts/
helm repo update
helm upgrade --install --namespace kube-system --values ./traefik-values.yaml traefik ibb/ibb-traefik
