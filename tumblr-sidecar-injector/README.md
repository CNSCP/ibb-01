# Tumbler Sidecar Injector

A Kubernetes Sidecar injector.

Homepage: https://github.com/tumblr/k8s-sidecar-injector/

## Setup

1. Generate TLS Certs

```
#--> Make sure tls/ca.conf and tls/csr-prod.conf contain valid information

DEPLOYMENT=ibb CLUSTER=01 ruby tls/new-cluster-injector-cert.rb
```

2. Add the generated `ca.crt` to the Mutating Webhook Configuration

```
cat tls/ibb/01/ca.crt | base64 | tr -d '\n'

OR sed Directly into mutating-webhook-configuration.yaml

CA_BUNDLE_B64="$(cat tls/ibb/01/ca.crt | base64 | tr -d '\n')"
sed -i '' \
  -e "s/__CA_BUNDLE_BASE64__/$CA_BUNDLE_B64/g" \
  sidecar-injector/mutating-webhook-configuration.yaml
```

[!] NOTE: Due to the many variations of `sed`, you may or may not need the single quotes after the `-i` flag.

3. Create the Kubernetes Secret containing the certificates generated in Step 1. Be sure to put these secrets in the same namespace as the mutating web hook pods (Usually `kube-system`)

```
kubectl create secret generic \
  k8s-sidecar-injector \
  --namespace kube-system \
  --from-file=tls/ibb/01/sidecar-injector.crt \
  --from-file=tls/ibb/01/sidecar-injector.key
```

[!] If this secret is named anything other than `k8s-sidecar-injector` you'll need to update the `imagePullSecrets` in the Sidecar Injector's Service Account

4. Apply all the things

```
kubectl apply -f sidecar-injector
```



TODO: Figure this out.

Left off where applying a demo pod was not adding the sidecars. Tried with the upstream examples/kubernetes/configmaps & debug pod, but same reuslt --> no sidecar injecton

Look into setting up service per the docs.

