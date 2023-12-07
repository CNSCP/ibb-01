# KTunnel POC

Proof of Concept for KTunnel to tunnel traffic from IBB to Padi

# Instructions

* Deploy ibb-deployment.yaml
* Exec into `ktunnel` pod

```
apt-get update
apt-get install -y curl wget vim

cd

# Get KTunnel Binary
wget https://github.com/omrikiei/ktunnel/releases/download/v1.6.1/ktunnel_1.6.1_Linux_x86_64.tar.gz
tar -xf ktunnel_1.6.1_Linux_x86_64.tar.gz

# Get Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
chmod +x kubectl

mv kubectl ktunnel /usr/local/bin/

# Get gcloud CLI
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-454.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-454.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
gcloud components install gke-gcloud-auth-plugin
gcloud auth login
gcloud config set project padi-staging

# --> Add KubeConfig for Padi Cluster

# Test Kubectl working
kubectl get pods

# Test that service is available locally
curl localhost:8080
--> Hello World

ktunnel expose [NAME] [PORT]
ktunnel expose my-app-name 8080
``` 

* Start demo pod on Padi cluster

```
# Padi Cluster Pod

apt-get install -y curl
curl my-app-name.default.svc.cluster.local:8080
--> Hello World
```

* Set up reverse proxy on Padi Pod to serve content of the service:

```
apt-get install -y nginx vim

# Edit the /etc/nginx/site-enabled/default file:

  location / {
    # First attempt to serve request as file, then
    # as directory, then fall back to displaying a 404.
    #try_files $uri $uri/ =404;

    proxy_pass        http://my-app-name.default.svc.cluster.local:8080;
    proxy_redirect    off;
    proxy_set_header  X-Remote-Addr $remote_addr;
    proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header  X-Forwarded-Host $server_name;
  }
```

* Test out by port fowrading the padi reverse proxy pod to your local device

```
kubectl --context padi-staging port-forward [POD] 8080:80
```
* Open `[localhost:8080](http://localhost:8080) on your local device

