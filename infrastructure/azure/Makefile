default: all

backend_instance_id := relaxed-cockatoo

backend_config:
	az keyvault secret download \
		--name azurerm-backend-tfvars \
		--vault-name kv-$(backend_instance_id) \
		--file azurerm.backend.tfvars

aad_script:
	az keyvault secret download \
		--name add-azureadroles-ps1 \
		--vault-name kv-$(backend_instance_id) \
		--file Add-AzureAdRoles.ps1

clean: config
	terraform destroy -auto-approve

clean_plugins:
	rm -rf terraform.d/
	rm -rf .terraform/plugins

install_plugins:
	mkdir -p terraform.d/plugins
	cp -R ~/.terraform.d/plugins/ terraform.d/

fmt:
	terraform fmt -recursive

init:
	terraform init --upgrade -backend-config azurerm.backend.tfvars
	terraform -v
	terraform providers

config:
	@echo 'resource_group_name="rg-$(instance_id)"' > terraform.auto.tfvars
	@echo 'backend_resource_group_name="rg-backend-$(backend_instance_id)"' >> terraform.auto.tfvars

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