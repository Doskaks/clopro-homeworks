# NAT-инстанс
resource "yandex_compute_instance" "nat_instance" {
  name        = "nat-instance"
  zone        = var.default_zone
  platform_id = "standard-v3"
  description = "NAT instance as gateway for private subnet"

  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }

  scheduling_policy {
    preemptible = var.vm_resources.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.nat_image_id
      size     = 10
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    ip_address         = var.nat_instance_ip
    nat                = true
    nat_ip_address     = yandex_vpc_address.nat_public_ip.external_ipv4_address[0].address
    security_group_ids = [yandex_vpc_security_group.default.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init.tpl", {
      public_key = file(var.public_key_path)
    })
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    serial-port-enable = 1
  }

  allow_stopping_for_update = true
}

# Публичная ВМ
resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  zone        = var.default_zone
  platform_id = "standard-v3"
  description = "Public VM with internet access"

  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }

  scheduling_policy {
    preemptible = var.vm_resources.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = 10
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    nat_ip_address     = yandex_vpc_address.public_vm_public_ip.external_ipv4_address[0].address
    security_group_ids = [yandex_vpc_security_group.default.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init-public.tpl", {
      public_key = file(var.public_key_path)
    })
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    serial-port-enable = 1
  }

  allow_stopping_for_update = true
}

# Приватная ВМ
resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  zone        = var.default_zone
  platform_id = "standard-v3"
  description = "Private VM without public IP"

  resources {
    cores         = var.vm_resources.cores
    memory        = var.vm_resources.memory
    core_fraction = var.vm_resources.core_fraction
  }

  scheduling_policy {
    preemptible = var.vm_resources.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_image_id
      size     = 10
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.private.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.default.id]
  }

  metadata = {
    user-data = templatefile("${path.module}/cloud-init-private.tpl", {
      public_key = file(var.public_key_path)
    })
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
    serial-port-enable = 1
  }

  allow_stopping_for_update = true
}