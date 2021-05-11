SHELL := /bin/bash

#
#  Errors:
#
#	Makefile:2: *** missing separator.  Stop.
#   https://stackoverflow.com/questions/18936337/makefile1-missing-separator-stop
#

#
#  Repository
#

repository.message: info
	@echo "Have a look at the README.md"

repository.git_add_all:
	git add .

repository.git_commit_all: repository.git_add_all
	git commit -m "ADD $(git status)"

repository.push: repository.git_commit_all
	git push

repository.open:
	chromium-browser "https://github.com/nk-designz/distributed_prometheus"
#
#  Project
#

project.install:
	apt-add-repository --yes --update ppa:ansible/ansible && \
	apt update && \
	apt install -y \
	  graphviz \
	  chromium-browser \
	  texlive-full \
	  python3-pip \
	  libssl-dev \
	  software-properties-common \
	  ansible \
	  jq && \
	ansible-galaxy collection install containers.podman && \
	ansible-galaxy collection install ansible.posix


project.billing: infrastructure.check_token
	@echo -e -n "\nThe costs of this month are:\t" && \
	curl -s -X GET \
	-H "Content-Type: application/json" \
	-H "Authorization: Bearer ${DO_PAT}" \
	"https://api.digitalocean.com/v2/customers/my/balance" \
	| jq .month_to_date_balance \
	| sed 's/"//g'

#
#  Infrastructure
#

infrastructure.check_token:
	@scripts/check_do_token.sh

infrastructure.validate_terraform: infrastructure.init
	cd infra && \
	terraform validate

infrastructure.plan: infrastructure.validate_terraform infrastructure.check_token
	cd infra && \
	echo "${DO_PAT}" && \
	terraform plan \
		-var "do_token=${DO_PAT}" \
		-var "pvt_key=${HOME}/.ssh/id_rsa"

infrastructure.graph: infrastructure.plan 
	terraform graph | dot -Tsvg > graph.svg

infrastructure.apply: infrastructure.plan
	cd infra && \
	terraform apply \
		-var "do_token=${DO_PAT}" \
		-var "pvt_key=${HOME}/.ssh/id_rsa" \
		-auto-approve && \
	git add terraform.tfstat*

infrastructure.destroy: infrastructure.plan
	cd infra && \
	terraform destroy \
		-var "do_token=${DO_PAT}" \
		-var "pvt_key=${HOME}/.ssh/id_rsa" \
		-auto-approve && \
	git add terraform.tfstat*

infrastructure.state:
	cd infra && \
	terraform show terraform.tfstate

infrastructure.init: 
	cd infra && \
	terraform init

#
#  Documentation
#

documentation.compile:
	cd docs && \
	latexmk -pdf  \
	 distributed_prometheus.tex > /dev/null

documentation.review_compile: documentation.compile
	cd docs && \
	pandoc \
	    distributed_prometheus.tex \
	 -o distributed_prometheus.docx

documentation.get_log:
	[ -e "docs/distributed_prometheus.log" ] && cat docs/*.log || exit 0

documentation.clean: documentation.get_log
	@ echo "Removing files:" && \
	cd docs && \
	ls \
	| grep . \
	| grep -E -v '*.tex|*.pdf|*.docx|assets|dist|css|gulpfile.js|index.html|js|package.json|package-lock.json|plugin|REVEALJS_LICENSE|test' \
	| tee /dev/tty \
	| xargs rm -f

documentation.open: documentation.compile documentation.clean
	chromium-browser ${PWD}/docs/distributed_prometheus.pdf

#
#  Presentation
#

presentation.open:
	chromium-browser ${PWD}/docs/index.html

#
#  Ansible
#

ansible.manual_inventory:
	@vim inventory/hosts.ini

ansible.galaxy_get_roles:
	ansible-galaxy install -p roles -r roles/requirements.yml

ansible.run:  ansible.galaxy_get_roles	inventory/hosts.ini
	ANSIBLE_HOST_KEY_CHECKING=false \
	ansible-playbook \
	-e 'ansible_python_interpreter=/usr/bin/python3' \
	-i inventory/hosts.ini \
	main.yml

#
#  Project
#

install: repository.install
	@echo "Installed Project"

apply-all: infrastructure.apply ansible.run
	@echo "Initialized Project"

apply: ansible.manual_inventory ansible.run
	@echo "Initialized Project"

destroy: infrastructure.destroy
	@echo "Destroyed Project"

redeploy: destroy apply-all
	@echo "Redeployed Project"

push: documentation.review_compile documentation.clean repository.push
	@echo "Pushed project"

billing: project.billing

info:
	@echo -e "Available plans:\n\tapply:\t\tInitialize Project\n\tdestroy:\tDestroy Project\n\tpush:\t\tPush Project\n\tinstall:\tInstall Project\n"

web: repository.open
	@echo "Opening in browser"