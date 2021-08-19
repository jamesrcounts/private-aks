default: all

backend_instance_id := relaxed-cockatoo
state_prefix := networking

backend_config:
	az keyvault secret download \
		--name azurerm-backend-tfvars \
		--vault-name kv-$(backend_instance_id) \
		--file azurerm.backend.tfvars

	sed -i \
		's/private-aks.tfstate/$(state_prefix).tfstate/' \
		azurerm.backend.tfvars

aad_script:
	az keyvault secret download \
		--name add-azuread-roles-sh \
		--vault-name kv-$(backend_instance_id) \
		--file add-azuread-roles.sh

clean: config
	terraform destroy -auto-approve

fmt:
	terraform fmt -recursive

init:
	terraform init --upgrade -backend-config azurerm.backend.tfvars
	terraform -v
	terraform providers

config:
	@echo 'backend_resource_group_name="rg-backend-$(backend_instance_id)"' > terraform.auto.tfvars

validate:
	terraform validate

plan: config fmt validate
	terraform plan -out plan.tfplan

apply:
	terraform apply plan.tfplan
	rm plan.tfplan

all: init plan

login:
	az login
	az account set --subscription "Jim Counts (Personal)"
	az account show --output table