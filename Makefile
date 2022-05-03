.PHONY: init generate-configmap clean fill-domain deploy

init: init-datadict create-tls generate-configmap fill-domain

init-datadict:
	mkdir -p /opt/kubevolume/datadictionary
	if [ ! -L /opt/kubevolume/datadictionary ]; then \
		ln -s ${PWD}/datadictionary /opt/kubevolume/; \
	fi

create-tls:
	 kubectl create secret tls ingress-cert --dry-run=client -oyaml \
	 --key=Secrets/TLS/service.key --cert=Secrets/TLS/service.crt \
	 > deploy/ingress-cert.yaml

generate-configmap:
	find deploy -type f -name create_config_yaml.sh -exec ./{} \;

clean:
	find deploy -type d -name config -exec rm -rf {} +

fill-domain:
	sed -e 's/<DOMAIN>/${DOMAIN}/' templates/ingress.yaml > deploy/ingress.yaml
	sed -e 's/<DOMAIN>/${DOMAIN}/' templates/jupyter-deploy.yaml > deploy/jupyter/jupyter-deploy.yaml

deploy:
	kubectl apply -f deploy -R |grep -v unchanged
	
