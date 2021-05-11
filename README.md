# Distributed Prometheus
Spin up prometheus backed by [m3](https://m3db.io) using ansible.
## Documentation
The [documentation](doc/distributed_prometheus.pdf) is written in german due to external requirements.
## Getting started
### Prerequesites
* make
* terraform        _optional_
* ansible
* pdflatex         _optional_
* chromium-browser _optional_
### With Terraform
1. Export your [DO](https://digitalocean.com) API Token:
   ```bash
   export DO_PAT="<token>"
   ```
2. Run the ```make``` plan:
   ```bash
   make apply-all
   ```
### Without Terraform
1. Start the ```make``` plan:
   ```bash
   make apply
   ```
2. Add the ansible-inventory:
   ```plain
   [nodes]
   165.xxx.87.xxx
   161.xxx.213.xxx
   165.xxx.172.xxx
   ```
3. Commit with ```:wq```
### Clean Up with Terraform
1. Export your [DO](https://digitalocean.com) API Token:
   ```bash
   export DO_PAT="<token>"
   ```
2. Run the ```make``` plan:
   ```bash
   make destroy
   ```
## Node-Setup
![Node Diagram](https://kroki.io/graphviz/svg/eNqNz00LgjAYB_B7n-Jhd8GyW3RJOxZB3UW3BxV0G3uJIPzu5UtrkoSXwf7b_7dnrCpUJktI4LkCqLMca9gDOQleGaEqXsAV1R2VJu9jbfPhNq2tNqhSmYZ9z2ueBUPgZNenrkCaiOWgR2rseK3hkbEFQHin4EMKZfxYCtZk3O1_5ilouna4_50oOQTfHkA3zmfX_tE2c9rxFicTjaChjCzxojnvokSDpkSrJ6p08RJ5OyfHgmtbB6Gn0j6ait3artoXWCOOqA==)

## Checklist
- [x] infrastructure automation
- [x] common sofware
- [x] node exporter role
- [x] etcd cluster role
- [x] m3db cluster role 
- [x] consul cluster role
- [x] prometheus role
- [x] load balancer
- [x] grafana role
- [ ] documentation

## Draft
~~~bash
curl -X PUT localhost:8500/v1/catalog/register -d '{ "Node": "m3db-node-0", "Address": "207.154.219.36", "Service": { "ID": "node-0", "Service": "m3", "Address": "207.154.219.36", "Port": 7503 }}'
~~~