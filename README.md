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
   * Add the Flux CD Helm repository:
    ```sh
      helm repo add fluxcd https://charts.fluxcd.io
    ```
   * Install the HelmRelease Custom Resource Definition.
    ```sh
      kubectl apply -f helm-operator-crds-1.2.0.yaml 
    ```
   * Install Helm Operator for Helm 3.
    ```sh
      helm upgrade -i helm-operator fluxcd/helm-operator \
        --namespace flux \
        --set helm.versions=v3
    ```
   * Run kubectl apply on HelmRelease file.
    ```sh
    ```
   * for latest version visit https://docs.fluxcd.io/projects/helm-operator/en/stable/references/chart/
  
3. Monitoring - Prometheus with Grafana.
   * Install prometheus stack.
    ```sh
      ## instal stack
      helm install prometheus --namespace monitoring --create-namespace prometheus-community/kube-prometheus-stack
    ```
   * Make sure you have mysql-exporter enabled in devops repository on the helm chart.
   * You can find more information about that on the README file in the devops repository.
4. Logging - EFK stack.