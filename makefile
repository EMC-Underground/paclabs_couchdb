all: build

init:
	terraform init

validate: init
	terraform validate

build: validate
	terraform apply

debug: validate
	TF_LOG=TRACE terraform apply

destroy:
	echo "yes" | terraform destroy
