GO111MODULE=on

default: build

build:
	go install

init: build
	cp ~/go/bin/terraform-plugin-azprivatedns ~/.terraform.d/plugins/terraform-provider-azprivatedns
