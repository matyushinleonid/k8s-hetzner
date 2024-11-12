# k8s-hetzner

```bash
cd ./infrastructure
terraform apply -var="hcloud_token=$(cat ~/.hetzner/token)"
```

```bash
cd ./playbooks
ansible-playbook -i inventory.ini setup_cpl.yaml
```
