output "cpl_ipv6" {
  value       = hcloud_server.cpl_node_1.ipv6_address
  description = "The public IPv6 address of the control plane node"
}

output "worker_ipv6" {
  value       = hcloud_server.worker_node_1.ipv6_address
  description = "The public IPv6 address of the worker node"
}
