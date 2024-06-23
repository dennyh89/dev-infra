# Install on Azure

## Login to azure with CLI

```
az login
az account list --output table
az account set --subscription 2fc0173e-cada-4000-82db-566c79d396db
```

## Create TFstate backend storage

```
LOCATION="germanywestcentral"
RESOURCE_GROUP_NAME=tfstate
STORAGE_ACCOUNT_NAME=tfstate$RANDOM
CONTAINER_NAME=tfstate

az group create --name $RESOURCE_GROUP_NAME --location $LOCATION --tags author=dennyh purpose=devopschallenge

az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob --tags author=dennyh purpose=devopschallenge

az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME 

ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
```

## Set environment variables

Create .envrc file for direnv or manually export these variables.
clientId/Secret for a azure keyvault for external secrets operator.

TF_VAR_arm_access_key with the ACCOUNT_KEY from above for the tfstate backend.

```

# for vault access
export TF_VAR_client_id="afayxxxxx23b69"
export TF_VAR_client_secret="ZQCxxxxxxxZJb3h"

# for tfstate backend
export TF_VAR_arm_access_key="GpfWSb1JtxxxxxxSthToWvg=="

```

## Create Infrastructure

```
cd terraform/infra
terraform apply
```

## setup gitops on clusters

```
cd terraform/gitops-bootstrap
terraform apply
```


## Current problems
* path based routing: need to make weather-app proxy aware because of not creating wildcard certs and trafficmanager restrictions
* terraform destroy on gitops-bootstrap module deletes argocd before destroying and finalizing the bootstrap application that also creates a loadbalancer service, which leads the infrastructure destroy later to fail because of the loadbalancer still being used 
* certificate creation with letsencrypt and acme works in single cluster mode, but not in loadbalanced active-active because of the http challenge possibly not working, might need to switch to DNS challenge, but its only in paid plans