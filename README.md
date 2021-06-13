## Infrastructure files for portfolio

Terraform Files:
1. Terraform files for provisioning EKS and ECR on AWS cloud.
2. Terraform files for provisioning GKE on Google cloud platform.

Helm files:
1. nginx-ingress.
  * install cert-manager
  ```sh
    ## add cert-manager repo to helm
    helm repo add jetstack https://charts.jetstack.io && helm repo update
  ```  
  ```sh
    ## install cert-manager
     helm install \
       cert-manager jetstack/cert-manager \
       --namespace cert-manager \
       --create-namespace \
       --set installCRDs=true 
  ```

  * install nginx-ingress
  ```sh
    helm install ingress-nginx ingress-nginx-3.32.0.tgz -f value-ingress-nginx-3.32.0.yaml
  ```

2. FluxCD
3. Monitoring - Prometheus with Grafana.
   * Install prometheus stack.
  ```sh
    ## instal stack
    helm install prometheus --namespace monitoring --create-namespace prometheus-community/kube-prometheus-stack
  ```
   * install mysql exporter 
  ```sh
    ## go to repo and install mysql helm chart
    https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-mysql-exporter
  ``` 

  ```sh
    ## Install the chart
    helm install -n monitoring mysql-exporter prometheus-mysql-exporter-1.2.0.tgz -f values-prometheus-mysql-exporter-1.2.0.yaml
  
  ```
  ```sh
  
  ```
  ```sh
  
  ```
4. Logging - EFK stack.