# Dapr IBB

## Installation

```
helm reop add dapr https://dapr.github.io/helm-charts
helm repo update
```

```
helm upgrade --install dapr dapr/dapr \
  --version=1.12 \
  --namespace dapr-system \
  --create-namespace \
  --wait
```


