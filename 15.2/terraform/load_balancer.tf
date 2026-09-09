# Создаем сетевой балансировщик
resource "yandex_lb_network_load_balancer" "lamp_lb" {
  name = "lamp-load-balancer"
  type = "external"

  listener {
    name        = "http-listener"
    port        = 80
    target_port = 80
    protocol    = "tcp"
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    # Используем целевую группу из Instance Group
    target_group_id = yandex_compute_instance_group.lamp_group.load_balancer[0].target_group_id

    healthcheck {
      name                = "http-healthcheck"
      interval            = 30
      timeout             = 10
      unhealthy_threshold = 3
      healthy_threshold   = 2

      http_options {
        port = 80
        path = "/"
      }
    }
  }

  depends_on = [
    yandex_compute_instance_group.lamp_group
  ]
}