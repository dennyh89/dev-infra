# Connect to Cluster

```
az login
az account set --subscription 89535820-f404-4ac0-af08-8646327bc3f7
az aks get-credentials --resource-group dev --name dev --overwrite-existing

kubectl get pods -A
```

# Install ArgoCD

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


brew install argocd

# publish UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

# Connect to Argo UI
```
kubectl get secret -n argocd argocd-initial-admin-secret -o yaml | yq .data.password | base64 -d

# OR

argocd admin initial-password -n argocd
```

# create vault secret
```
kubectl apply -f vault-secret.yaml -n cluster-bootstrap
```
, deploy argo, and create initial applications, than only commit to git