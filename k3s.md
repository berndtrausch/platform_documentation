># Introduction

Below is a description of the installation and setup of K3s.

What is K3s:

   - Lightweight Kubernetes (see https://k3s.io/)
   - The certified Kubernetes distribution built for IoT & Edge computing

# Why Use K3s

  - Perfect for Edge
    - K3s is a highly available, certified Kubernetes distribution designed for production workloads in unattended, resource-constrained, remote locations or inside IoT appliances.

  - Simplified & Secure
    - K3s is packaged as a single <70MB binary that reduces the dependencies and steps needed to install, run and auto-update a production Kubernetes cluster.

  - Optimized for ARM
    - Both ARM64 and ARMv7 are supported with binaries and multiarch images available for both. K3s works great on something as small as a Raspberry Pi to an AWS a1.4xlarge 32GiB server.

# Step 1: Install K3s without traefik

``` bash
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--no-deploy traefik" INSTALL_K3S_SKIP_START=true K3S_URL=https://<your-server-ip>:6443 sh -s -
```
Testen ob K3s verfügbar: sudo k3s kubectl get node

see https://k3s.io/ for further information

# Step 2: Install Helm

see https://github.com/helm/helm/releases for further information

# Step 3: Install yq

wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq &&\ chmod +x /usr/bin/yq

# Step 4: Install an Ingress Controller

``` bash
helm upgrade --install ingress-nginx ingress-nginx --version 4.4.2 --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.replicaCount=1 --set controller.ingressClassResource.default=true
```

# Step 4: Install Cert-Manager

Cert-Manager is a Kubernetes add-on to automate the management and issuance of TLS certificates from various issuing sources. It will ensure certificates are valid and up to date.

The add-on uses Issuers (Namespaced) or ClusterIssuers (Cluster-wide) to manage the issuance of certificates. In this lab, we will use a ClusterIssuer to issue certificates. The Issuer is responsible for communicating with the certificate authority to obtain certificates.

**Install Cert-Manager**

To install Cert-Manager, you can use the following command:

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager --create-namespace --namespace cert-manager --set installCRDs=true --wait
```

**Add the ACME ClusterIssuer**

To issue certificates, we need to add a ClusterIssuer. In this lab, we will use the Let's Encrypt staging environment to issue certificates. This is useful for testing purposes.

You can add the ClusterIssuer with the following manifest:

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt
spec:
  acme:
    email: user@example.com
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      name: example-issuer-account-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
      - http01:
          ingress:
            ingressClassName: nginx
```

**Verify the Installation**

After the installation, you can verify the installation by running the following command:

```bash
kubectl get pods -n cert-manager
```

Furthermore, you can verify the installation of the ClusterIssuer by running the following command:

```bash
kubectl get clusterissuers.cert-manager.io
```

If you see the pods of Cert-Manager, you have successfully installed Cert-Manager and can proceed with the next steps.
