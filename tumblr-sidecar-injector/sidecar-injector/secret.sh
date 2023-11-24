#!/bin/bash

kubectl create secret generic \
  k8s-sidecar-injector \
  --namespace kube-system \
  --from-file=tls/ibb/01/sidecar-injector.crt \
  --from-file=tls/ibb/01/sidecar-injector.key
