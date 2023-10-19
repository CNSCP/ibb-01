# IBB Traefik

A customized traefik installation which opens ports 5011/TCP and 4911/TCP to ingress

## Installation

```
$ helm repo add traefik https://traefik.github.io/charts
$ helm repo update

#--- or just run ./install.sh
$ helm upgrade --install \
    --namespace kube-system \
    --values ./traefik-values.yaml \
    traefik \
    traefik/traefik


#--- Check that Traefik was installed
$ kubectl get ingressclasses -A

#--- NAME      CONTROLLER
#--- traefik   traefik.io/ingress-controller
```
