# Run development environment for Helm charts
# Included: Helm, kubectl, nodejs, yamllint

FROM tliin/remote-debian-base:master
ARG node_major=18
USER root
# Install Python
RUN apt-get install --no-install-recommends -y \
    python3 \
    python3-yaml


## SETUP ADDITIONAL TOOLS ##
# Setup Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor |  tee /usr/share/keyrings/helm.gpg > /dev/null; \
    echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list

# Install kubectl
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list

# Install node.js
RUN curl -fsSL https://deb.nodesource.com/setup_${node_major}.x | bash -

# Run apt install
RUN apt-get update && apt-get install -y --no-install-recommends \
    helm \
    kubectl \
    nodejs

# Run npm installer
RUN npm install yaml-lint;

USER 1000