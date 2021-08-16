default: plan

backend_instance_id := relaxed-cockatoo

init:
	terraform init
	terraform -v 
	terraform providers

plan: fmt config init
	terraform plan -out plan.tfplan

apply:
	terraform apply plan.tfplan

fmt:
	cd .. && terraform fmt -recursive

config:
	@echo 'backend_resource_group_name="rg-backend-$(backend_instance_id)"' > terraform.auto.tfvars