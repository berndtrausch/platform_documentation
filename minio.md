># Installation

you need following yaml-Files:

certificate-api-prod.yaml
certificate-webgui-prod.yaml
cluster-issuer.yaml
minio-api-ingress.yaml
minio-api-service.yaml
minio-dev.yaml
minio-webgui-ingress.yaml
minio-webgui-service.yaml

or a complete yaml for everything in one file ;-)

complete.yaml:

``` yaml

apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ssl-cert-api
  namespace: default
spec:
  secretName: ssl-cert-api
  issuerRef:
    name: letsencrypt-production
    kind: ClusterIssuer
  commonName: s3.cloud-prj.eu
  dnsNames:
  - s3.cloud-prj.eu

---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ssl-cert-webgui
  namespace: default
spec:
  secretName: ssl-cert-webgui
  issuerRef:
    name: letsencrypt-production
    kind: ClusterIssuer
  commonName: minio.cloud-prj.eu
  dnsNames:
  - minio.cloud-prj.eu

---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-production
  namespace: default
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: thomas.weyse@gmx.at
    privateKeySecretRef:
      name: letsencrypt-production
    solvers:
    - selector: {}
      http01:
        ingress:
          class: nginx

---
apiVersion: v1
kind: Namespace
metadata:
  name: minio-dev # Change this value if you want a different namespace name
  labels:
    name: minio-dev # Change this value to match metadata.name
---
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: minio
  name: minio
  namespace: minio-dev # Change this value to match the namespace metadata.name
spec:
  containers:
  - name: minio
    image: quay.io/minio/minio:latest
    command:
    - /bin/bash
    - -c
    args: 
    - minio server /data --console-address :9090
    volumeMounts:
    - mountPath: /data
      name: localvolume # Corresponds to the `spec.volumes` Persistent Volume
  volumes:
  - name: localvolume
    hostPath: # MinIO generally recommends using locally-attached volumes
      path: /mnt/disk1/data # Specify a path to a local drive or volume on the Kubernetes worker node
      type: DirectoryOrCreate # The path to the last directory must exist
---
apiVersion: v1
kind: Service
metadata:
  name: minio-api-service
  namespace: minio-dev
spec:
  selector:
    app: minio
  type: ClusterIP
  ports:
  - protocol: TCP
    port: 9000
    targetPort: 9000
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minio-api-ingress
  namespace: minio-dev
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
  - hosts:
      - s3.cloud-prj.eu
    secretName: ssl-cert-api
  rules:
  - host: s3.cloud-prj.eu
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: minio-api-service
            port:
              number: 9000
---
apiVersion: v1
kind: Service
metadata:
  name: minio-service
  namespace: minio-dev
spec:
  selector:
    app: minio
  type: ClusterIP
  ports:
  - protocol: TCP
    port: 9090
    targetPort: 9090
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minio-webgui-ingress
  namespace: minio-dev
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  tls:
  - hosts:
      - minio.cloud-prj.eu
    secretName: ssl-cert-webgui
  rules:
  - host: minio.cloud-prj.eu
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service: 
            name: minio-service
            port:
              number: 9090

```