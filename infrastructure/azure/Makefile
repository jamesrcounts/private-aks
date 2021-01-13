default: apply

clean:
	terraform destroy -auto-approve

clean_plugins:
	rm -rf terraform.d/
	rm -rf .terraform/plugins

install_plugins:
	mkdir -p terraform.d/plugins
	cp -R ~/.terraform.d/plugins/ terraform.d/

fmt:
	terraform fmt -recursive

init: fmt install_plugins
	terraform init

validate:
	terraform validate

apply: init validate
	terraform apply