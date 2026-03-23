# Local ArgoCD Deployment with Terraform & Kind

This project automates the creation of a local Kubernetes environment using **Kind** and installs **ArgoCD** using the Terraform **Helm** provider.

## 🚀 What this repository does

1. **Creates a Kubernetes Cluster**  
   Uses the `tehcyx/kind` provider to spin up a local cluster named `dev-cluster`.

2. **Configures Networking**  
   Maps host ports `80` and `443` to the Kind control-plane for future ingress use.

3. **Sets up Namespace**  
   Creates a dedicated `argocd` namespace for isolation.

4. **Deploys ArgoCD**  
   Installs the latest official ArgoCD Helm chart from `argoproj.github.io`.

---

## 🛠 Prerequisites

- [Docker](https://www.docker.com) (running)
- [Terraform](https://www.terraform.io)
- [kubectl](https://kubernetes.io)

---

## 💻 Usage

### 1. Initialize and Deploy

Run the following commands to provision the cluster and ArgoCD:

```bash
terraform init
terraform apply
```

For multi cluster setup you can pass a list of environments:

```bash
terraform init
terraform apply -var='environments=["dev","uat","prod"]'
```

Argo CD will only be installed into the dev cluster as we can deploy to multiple clusters from one ArgoCD instance 

### 2. Access the ArgoCD UI

Since the service is internal, use kubectl to port-forward the API server to your local machine:

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Now open your browser and navigate to:

```bash
https://localhost:8080
```

### 3. Extract the Admin Password

The default username is admin. Retrieve the auto-generated password with:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

### 4. Destroy the Environment

To destroy the cluster and all associated resources:

```bash
terraform destroy
```