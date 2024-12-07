# k8s-hetzner

This repository provides a set of Terraform and Ansible scripts to provision a Kubernetes cluster on Hetzner Cloud.
We use ipv4/ipv6 dual-stack networking and Cilium as the CNI.


## How to provision a Kubernetes cluster

Provision base infrastructure on Hetzner Cloud
```bash
cd ./infrastructure
terraform apply -var="hcloud_token=$(cat ~/.hetzner/token)"
```

Once the VMs are provisioned, one can access them via SSH
```bash
ssh -i ~/.ssh/hcloud root@<VM public ipv6>
```

Configure VMs and install k8s with kubeadm. Update `inventory.ini` with the public IPs of the VMs prior to running the playbooks
```bash
cd ./playbooks
ansible-playbook -i inventory.ini setup_cpl.yaml
ansible-playbook -i inventory.ini setup_workers.yaml
```
After this the kubeconfig file will be available at `~/.kube/hetzner.conf`

Install CNI, Kong Ingress Controller and HAProxy
```bash
ansible-playbook -i inventory.ini setup_networking.yaml
```

## Usage examples

### Expose a service to the internet 

Suppose you own a domain `example.com` and you want to expose a simple nginx web server to the internet.
One should create a DNS record for the domain `nginx.example.com` pointing to the public ipv6 addresses of the HAProxy VM (in our case it is the CPL machine).
```bash
cd ./examples
kubectl apply -f exposed-nginx-web-server.yaml
```
Remember to set the corresponding domain in the yaml file Ingress resource.
