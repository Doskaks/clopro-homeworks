output "connect_to_nat" {
  description = "SSH command to connect to NAT instance"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${yandex_vpc_address.nat_public_ip.external_ipv4_address[0].address}"
}

output "nat_instance_public_ip" {
  description = "Public IP of NAT instance"
  value       = yandex_vpc_address.nat_public_ip.external_ipv4_address[0].address
}

output "nat_instance_private_ip" {
  description = "Private IP of NAT instance"
  value       = yandex_compute_instance.nat_instance.network_interface[0].ip_address
}

output "nat_instance_info" {
  description = "NAT instance configuration"
  value = {
    name          = yandex_compute_instance.nat_instance.name
    preemptible   = yandex_compute_instance.nat_instance.scheduling_policy[0].preemptible
    core_fraction = yandex_compute_instance.nat_instance.resources[0].core_fraction
    public_ip     = yandex_vpc_address.nat_public_ip.external_ipv4_address[0].address
    private_ip    = yandex_compute_instance.nat_instance.network_interface[0].ip_address
    is_static     = true
  }
}

output "public_vm_public_ip" {
  description = "Static public IP of public VM"
  value       = yandex_vpc_address.public_vm_public_ip.external_ipv4_address[0].address
}

output "public_vm_private_ip" {
  description = "Private IP of public VM"
  value       = yandex_compute_instance.public_vm.network_interface[0].ip_address
}

output "public_vm_info" {
  description = "Public VM configuration"
  value = {
    name          = yandex_compute_instance.public_vm.name
    preemptible   = yandex_compute_instance.public_vm.scheduling_policy[0].preemptible
    core_fraction = yandex_compute_instance.public_vm.resources[0].core_fraction
    public_ip     = yandex_vpc_address.public_vm_public_ip.external_ipv4_address[0].address
    private_ip    = yandex_compute_instance.public_vm.network_interface[0].ip_address
    is_static     = true
  }
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

output "ssh_public_vm" {
  description = "SSH command to connect to public VM"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${yandex_vpc_address.public_vm_public_ip.external_ipv4_address[0].address}"
}

output "ssh_private_vm_through_public" {
  description = "SSH command to connect to private VM through public VM"
  value       = "ssh -i ~/.ssh/id_rsa -J ubuntu@${yandex_vpc_address.public_vm_public_ip.external_ipv4_address[0].address} ubuntu@${yandex_compute_instance.private_vm.network_interface[0].ip_address}"
}

output "test_internet_public" {
  description = "Command to test internet from public VM"
  value       = "ssh -i ~/.ssh/id_rsa ubuntu@${yandex_vpc_address.public_vm_public_ip.external_ipv4_address[0].address} 'ping -c 4 8.8.8.8'"
}

output "test_internet_private" {
  description = "Command to test internet from private VM through public VM"
  value       = "ssh -i ~/.ssh/id_rsa -J ubuntu@${yandex_vpc_address.public_vm_public_ip.external_ipv4_address[0].address} ubuntu@${yandex_compute_instance.private_vm.network_interface[0].ip_address} 'ping -c 4 8.8.8.8'"
}

output "network_name" {
  description = "VPC network name"
  value       = yandex_vpc_network.my_network.name
}

output "public_subnet_cidr" {
  description = "Public subnet CIDR"
  value       = yandex_vpc_subnet.public.v4_cidr_blocks
}

output "private_subnet_cidr" {
  description = "Private subnet CIDR"
  value       = yandex_vpc_subnet.private.v4_cidr_blocks
}

# Object Storage
output "bucket_name" {
  description = "Name of the Object Storage bucket"
  value       = yandex_storage_bucket.student_bucket.bucket
}

output "image_url" {
  description = "URL of the image in Object Storage"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.student_bucket.bucket}/${yandex_storage_object.image.key}"
}

# Instance Group
output "instance_group_name" {
  description = "Name of the instance group"
  value       = yandex_compute_instance_group.lamp_group.name
}

output "instance_group_status" {
  description = "Status of the instance group"
  value       = yandex_compute_instance_group.lamp_group.status
}

# Load Balancer
output "load_balancer_ip" {
  description = "Public IP of the load balancer"
  value       = element([for listener in yandex_lb_network_load_balancer.lamp_lb.listener : element(tolist(listener.external_address_spec), 0).address if listener.name == "http-listener"], 0)
}

output "load_balancer_url" {
  description = "URL of the load balancer"
  value       = "http://${element([for listener in yandex_lb_network_load_balancer.lamp_lb.listener : element(tolist(listener.external_address_spec), 0).address if listener.name == "http-listener"], 0)}/"
}

# KMS
output "kms_key_id" {
  description = "ID of the KMS key"
  value       = yandex_kms_symmetric_key.bucket_key.id
}

output "kms_key_name" {
  description = "Name of the KMS key"
  value       = yandex_kms_symmetric_key.bucket_key.name
}