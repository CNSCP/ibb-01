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
  kubernetes/mutating-webhook-configuration.yaml
```

[!] NOTE: Due to the many variations of `sed`, you may or may not need the single quotes after the `-i` flag.

3. Create the Kubernetes Secret containing the certificates generated in Step 1. Be sure to put these secrets in the same namespace as the mutating web hook pods (Usually `kube-system`)

```
kubectl create secret generic \
  ibb-ktunnel-sidecar-injector \
  --namespace kube-system \
  --from-file=tls/ibb/01/sidecar-injector.crt \
  --from-file=tls/ibb/01/sidecar-injector.key
```

[!] If this secret is named anything other than `ibb-ktunnel-sidecar-injector` you'll need to update the `imagePullSecrets` in the Sidecar Injector's Service Account

4. Apply all the things

```
kubectl apply -f kubernetes/
```

Congrats! Your injector should now be working! You can try to annotate a pod and deploy it to see if it is working. Because the pod is annotated with `injector.ktunnel.ibbproject.com/request` and the value (`ibb-ktunnel`) matches that of a config we set up in `kubernetes/configuration-configmap.yaml`, the injector-debug pod will be injected with an additional container.

```
apiVersion: v1
kind: Pod
metadata:
  name: injector-debug
  annotations:
    injector.ktunnel.ibbproject.com/request: ibb-ktunnel
spec:
  containers:
  - image: ubuntu
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
    name: ubuntu
  restartPolicy: Never
```

