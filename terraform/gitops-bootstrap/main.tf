locals {
  # location = "northeurope"
  # location2 = "germanywestcentral"
  # prefix_name= "dennyh"
  # nodecount = 2
  # min_tags= {
  #   "author" =local.prefix_name
  #   "purpose" = "devopschallenge"
  # }
  
}



# Create argocd namespace
# and resources
# and cluster-bootstrap namespace

# data "kustomization" "argocd_install" {
  
#   # path to kustomization directory
#   path = "../../gitops-bootstrap/"
# }

# resource "kustomization_resource" "argocd_install" {

#   for_each = data.kustomization.argocd_install.ids

#   manifest = data.kustomization.argocd_install.manifests[each.value]

# }

module "kustomization_cluster_one" {
  source = "kbst.xyz/catalog/custom-manifests/kustomization"
  version = "0.4.0" # Ensure you check for the latest version

  configuration_base_key = "default"  # must match workspace name

  configuration = {
    default = {

    resources = [
      "${path.root}/../../gitops-bootstrap/",
    ]
    }
  }

}

resource "kubectl_manifest" "vault-secret" {
  depends_on = [module.kustomization_cluster_one]

  yaml_body = <<EOF
    apiVersion: v1
    kind: Secret
    metadata:
      name: vault-secret
      namespace: cluster-bootstrap
    type: Opaque
    data:
      ClientID: ${base64encode(var.client_id)} 
      ClientSecret: ${base64encode(var.client_secret)} 
    EOF
    }



# Create argocd namespace
# and resources
# and cluster-bootstrap namespace



module "kustomization_cluster_two" {
  source = "kbst.xyz/catalog/custom-manifests/kustomization"
  version = "0.4.0" # Ensure you check for the latest version
  configuration_base_key = "default"  # must match workspace name

  configuration = {
    default = {

    resources = [
      "${path.root}/../../gitops-bootstrap/",
    ]
    }
  }

  providers = {
    kustomization = kustomization.cluster-two
  }
}

resource "kubectl_manifest" "vault-secret2" {
  depends_on = [module.kustomization_cluster_two]

  yaml_body = <<EOF
    apiVersion: v1
    kind: Secret
    metadata:
      name: vault-secret
      namespace: cluster-bootstrap
    type: Opaque
    data:
      ClientID: ${base64encode(var.client_id)} 
      ClientSecret: ${base64encode(var.client_secret)} 
    EOF
  provider = kubectl.cluster-two
  }





