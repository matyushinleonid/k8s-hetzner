# k8s-hetzner

This repository provides a set of Terraform and Ansible scripts to provision a Kubernetes cluster on Hetzner Cloud.
We use ipv4/ipv6 dual-stack networking and Cilium as the CNI.

## How to use

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

Install CNI
```bash
helm install cilium cilium/cilium --version 1.16.3 \
  --namespace kube-system \
  --set ipam.mode=kubernetes \
  --set ipv6.enabled=true \
  --set ipv4.enabled=true \
  --set dualStack=true \
  --set nodeport.enabled=true \
  --set k8sServiceHost=10.0.1.5 \
  --set k8sServicePort=6443 \
  --set cluster.id=0 \
  --set cluster.name=k8s-cluster \
  --set global.eni.enabled=false \
  --set global.nodeinit.enabled=false
```
