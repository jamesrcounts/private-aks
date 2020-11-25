# SERVICE_PRINCIPAL_ID=$(az ad sp create-for-rbac --skip-assignment --name $KUBE_NAME -o json | jq -r '.appId')
resource "azuread_application" "aks_identity" {
  name = "${local.project}-cluster"
}

resource "azuread_service_principal" "aks_principal" {
  application_id = azuread_application.aks_identity.application_id
}

# SERVICE_PRINCIPAL_SECRET=$(az ad app credential reset --id $SERVICE_PRINCIPAL_ID -o json | jq '.password' -r)
resource "azuread_application_password" "aks_identity_application_password" {
  application_object_id = azuread_application.aks_identity.id
  description           = "Cluster Identity: ${local.project}"
  value                 = random_password.password.result
  end_date_relative     = "240h"
}

resource "random_password" "password" {
  length           = 16
  override_special = "_%@"
  special          = true
}
