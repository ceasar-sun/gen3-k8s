# gen3-k8s

Gen3 Commons migration from [compose-service](https://github.com/uc-cdis/compose-services/blob/master/docker-compose.yml) project

## Usage

### Host settings
> Increase memory limit a user can allocate for elasticsearch.

```shell
echo "* soft memlock unlimited" >>/etc/security/limits.conf 

echo "* hard memlock unlimited" >>/etc/security/limits.conf

echo "vm.max_map_count=655360" >> /etc/sysctl.conf    

sysctl --system
```

### First of all

> Generate all files we need

1. Generate config and credentails
  - `gitops.json` for setting portal rendering. ref: [portal_config](./docs/portal_config.md)

    ```shell
    $ export DOMAIN=<domain name>
    # ex: export DOMAIN=10.18.10.10.nip.io

    # bash creds_setup.sh $DOMAIN_NAME
    # For develop use xxx.nip.io
    # For Example
    $ bash creds_setup.sh $DOMAIN

    # Credentials, config and helpers will be placed in Secrets
    $ ls Secrets/
    TLS               etl_creds.json     gitops.json        indexd_settings.py     sheepdog_creds.json    user.yaml
    config_helper.py  fence-config.yaml  guppy_config.json  peregrine_creds.json   sheepdog_settings.py
    etlMapping.yaml   fenceJwtKeys       indexd_creds.json  peregrine_settings.py  test_config_helper.py
    ```

2. Install ingress controller
> https://kubernetes.github.io/ingress-nginx/deploy/#bare-metal

```shell
$ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.4/deploy/static/provider/baremetal/deploy.yaml

# Wait for installation done.
kubectl get pods -n ingress-nginx \
-l app.kubernetes.io/name=ingress-nginx --watch
```

3. Init project

```shell
# Prepare configmaps, secrets, and modify domain value automatically.
# You can run this command in any time you changed the config
$ make init
```

> clean config and secrets
`$ make clean`

4. Deploy all

```shell
# Cause on first deploy we don't have any data, you should comment out guppy section in nginx.conf
# Otherwise, revproxy service will keep restarting.
# https://github.com/uc-cdis/compose-services/blob/master/docs/setup.md#start-running-your-local-gen3-docker-compose-environment
$ vim nginx.conf 
  # location /guppy/ {
  #     proxy_pass http://guppy-service/;
  # }

$ make deploy
```

5. Since this project is for bare-metal installation, we need manually give it a externalIP

```shell
# Add externalIPs in ingress-controller service
# ex:
# spec:
#   externalIPs:
#   - 10.18.10.10
$ kubectl edit -ningress-nginx svc ingress-nginx-controller
```

6. Open Browser and check https://$DOMAIN is work.

