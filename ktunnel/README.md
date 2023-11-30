# KTunnel

Create Kube Config and Google Service Account JSON secrets

```
kubectl create secret generic kubeconfig \
  --from-file=config \
  --from-file=/path/to/gsa-key.json
```
