# GCloud

Auth to gCloud cluster with client secret key

```
gcloud iam service-accounts create sa-ktunnel

gcloud projects add-iam-policy-binding padi-staging \
--member=serviceAccount:sa-ktunnel@padi-staging.iam.gserviceaccount.com \
--role=roles/container.developer

gcloud iam service-accounts keys create gsa-key.json \
    --iam-account=sa-ktunnel@padi-staging.iam.gserviceaccount.com
```

Change the CA Data and Host of the included `kubeconfig` to that of the target cluster

Create a secret on the source cluster containing the kubeconfig and gsa-key.json information:

```
kubectl create secret generic kubeconfig \
  --from-file=config \
  --from-file=/path/to/gsa-key.json
```

Mount these files inside of the ktunnel side car

Run `gcloud auth activate-service-account --key-file=/root/.kube/gsa-key.json` to active the gcloud account

Run `ktunnel expose my-service-name PORT` in the ktunnel pod to run ktunnel and set up the service in the target cluster.
