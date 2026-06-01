output "vm_public_ip" {
  description = "Public IP address of the Kittygram VM."
  value       = yandex_compute_instance.kittygram.network_interface[0].nat_ip_address
}

output "vm_private_ip" {
  description = "Private IP address of the Kittygram VM."
  value       = yandex_compute_instance.kittygram.network_interface[0].ip_address
}

output "security_group_id" {
  description = "Security Group ID attached to the Kittygram VM."
  value       = yandex_vpc_security_group.kittygram.id
}

output "network_id" {
  description = "VPC network ID."
  value       = yandex_vpc_network.kittygram.id
}
