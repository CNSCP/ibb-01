#!/bin/bash

kubectl create secret generic \
  ibb-ktunnel-sidecar-injector \
  --namespace kube-system \
  --from-file=tls/ibb/01/sidecar-injector.crt \
  --from-file=tls/ibb/01/sidecar-injector.key
