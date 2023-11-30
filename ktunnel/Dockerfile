FROM ubuntu:22.04

RUN apt-get update \
  && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    gnupg \
    curl \
    vim \
    wget

WORKDIR /tmp

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list

RUN apt-get update \
  && apt-get install -y \
    google-cloud-cli \
    google-cloud-sdk-gke-gcloud-auth-plugin

RUN wget https://github.com/omrikiei/ktunnel/releases/download/v1.6.1/ktunnel_1.6.1_Linux_x86_64.tar.gz \
  && tar -xf ktunnel_1.6.1_Linux_x86_64.tar.gz \
  && chmod +x ktunnel \
  && mv ktunnel /usr/local/bin/

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
  && chmod +x kubectl \
  && mv kubectl /usr/local/bin/
