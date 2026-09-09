# Используем существующий сервисный аккаунт
data "yandex_iam_service_account" "instance_group_sa" {
  service_account_id = var.terraform_service_account_id
}

# Создаем группу ВМ с LAMP
resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-instance-group"
  description        = "Instance group with LAMP stack (preemptible, 20% CPU)"
  folder_id          = var.folder_id
  service_account_id = data.yandex_iam_service_account.instance_group_sa.id

  instance_template {
    platform_id = "standard-v3"
    
    resources {
      cores         = var.instance_group_resources.cores
      memory        = var.instance_group_resources.memory
      core_fraction = var.instance_group_resources.core_fraction
    }

    scheduling_policy {
      preemptible = var.instance_group_resources.preemptible
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = var.lamp_image_id
        size     = 20
        type     = var.disk_type
      }
    }

    network_interface {
      network_id         = yandex_vpc_network.my_network.id
      subnet_ids         = [yandex_vpc_subnet.public.id]
      nat                = true
      security_group_ids = [yandex_vpc_security_group.default.id]
    }

    metadata = {
  user-data = templatefile("${path.module}/cloud-init-lamp.tpl", {
    public_key = file(var.public_key_path)
    image_url  = "https://storage.yandexcloud.net/${yandex_storage_bucket.student_bucket.bucket}/${yandex_storage_object.image.key}"
  })
  serial-port-enable = 1
}
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  health_check {
    http_options {
      port = 80
      path = "/"
    }
    interval = 30
    timeout  = 10
    unhealthy_threshold = 3
    healthy_threshold   = 2
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
    max_creating    = 1
    max_deleting    = 1
  }

  load_balancer {
    # target_group_id НЕ УКАЗЫВАЕМ!
  }

  depends_on = [
    yandex_storage_object.image,
    yandex_vpc_subnet.public
  ]
}