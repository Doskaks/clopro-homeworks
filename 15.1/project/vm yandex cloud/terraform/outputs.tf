output "connect_to_nat" {
  description = "SSH command to connect to NAT instance"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${yandex_vpc_address.nat_public_ip.external_ipv4_address[0].address}"
}

output "ssh_public_vm" {
  description = "SSH command to connect to public VM"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${yandex_compute_instance.public_vm.network_interface[0].nat_ip_address}"
}

output "ssh_private_vm_through_public" {
  description = "SSH command to connect to private VM through public VM"
  value       = "ssh -i ~/.ssh/id_rsa -J ubuntu@${yandex_compute_instance.public_vm.network_interface[0].nat_ip_address} ubuntu@${yandex_compute_instance.private_vm.network_interface[0].ip_address}"
}

output "nat_instance_public_ip" {
  description = "Public IP of NAT instance"
  value       = yandex_vpc_address.nat_public_ip.external_ipv4_address[0].address
}

output "nat_instance_private_ip" {
  description = "Private IP of NAT instance"
  value       = yandex_compute_instance.nat_instance.network_interface[0].ip_address
}

output "public_vm_public_ip" {
  description = "Public IP of public VM"
  value       = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
}

output "public_vm_private_ip" {
  description = "Private IP of public VM"
  value       = yandex_compute_instance.public_vm.network_interface[0].ip_address
}

output "private_vm_private_ip" {
  description = "Private IP of private VM"
  value       = yandex_compute_instance.private_vm.network_interface[0].ip_address
}

output "private_vm_info" {
  description = "Private VM configuration"
  value = {
    name          = yandex_compute_instance.private_vm.name
    preemptible   = yandex_compute_instance.private_vm.scheduling_policy[0].preemptible
    core_fraction = yandex_compute_instance.private_vm.resources[0].core_fraction
    private_ip    = yandex_compute_instance.private_vm.network_interface[0].ip_address
  }
}

output "public_vm_info" {
  description = "Public VM configuration"
  value = {
    name          = yandex_compute_instance.public_vm.name
    preemptible   = yandex_compute_instance.public_vm.scheduling_policy[0].preemptible
    core_fraction = yandex_compute_instance.public_vm.resources[0].core_fraction
    public_ip     = yandex_compute_instance.public_vm.network_interface[0].nat_ip_address
    private_ip    = yandex_compute_instance.public_vm.network_interface[0].ip_address
  }
}

output "nat_instance_info" {
  description = "NAT instance configuration"
  value = {
    name          = yandex_compute_instance.nat_instance.name
    preemptible   = yandex_compute_instance.nat_instance.scheduling_policy[0].preemptible
    core_fraction = yandex_compute_instance.nat_instance.resources[0].core_fraction
    public_ip     = yandex_vpc_address.nat_public_ip.external_ipv4_address[0].address
    private_ip    = yandex_compute_instance.nat_instance.network_interface[0].ip_address
  }
}

output "test_internet_public" {
  description = "Command to test internet from public VM"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${yandex_compute_instance.public_vm.network_interface[0].nat_ip_address} 'ping -c 4 8.8.8.8'"
}

output "test_internet_private" {
  description = "Command to test internet from private VM through public VM"
  value       = "ssh -i ~/.ssh/id_rsa -J ubuntu@${yandex_compute_instance.public_vm.network_interface[0].nat_ip_address} ubuntu@${yandex_compute_instance.private_vm.network_interface[0].ip_address} 'ping -c 4 8.8.8.8'"
}