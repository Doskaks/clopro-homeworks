# 1. Создаем VPC сеть
resource "yandex_vpc_network" "my_network" {
  name        = "my-network"
  description = "Main VPC network"
}

# 2. Резервируем статический публичный IP-адрес для NAT-инстанса
resource "yandex_vpc_address" "nat_public_ip" {
  name        = "nat-public-ip"
  description = "Static public IP for NAT instance"
  
  external_ipv4_address {
    zone_id = var.default_zone
  }
  
}

# 3. Публичная подсеть
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my_network.id
  v4_cidr_blocks = var.public_subnet_cidr
  description    = "Public subnet with NAT instance"
}

# 4. Приватная подсеть с привязанным route table
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.my_network.id
  v4_cidr_blocks = var.private_subnet_cidr
  description    = "Private subnet without internet access"
  route_table_id = yandex_vpc_route_table.private_route.id
}

# 5. Route Table для приватной подсети
resource "yandex_vpc_route_table" "private_route" {
  name        = "private-route"
  network_id  = yandex_vpc_network.my_network.id
  description = "Route table for private subnet through NAT instance"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_instance_ip
  }
}

# 6. Группа безопасности
resource "yandex_vpc_security_group" "default" {
  name        = "default-sg"
  description = "Default security group for all VMs"
  network_id  = yandex_vpc_network.my_network.id

  ingress {
    protocol       = "TCP"
    description    = "SSH from anywhere"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "ANY"
    description    = "All traffic from internal networks"
    v4_cidr_blocks = ["192.168.10.0/24", "192.168.20.0/24"]
  }

  egress {
    protocol       = "ANY"
    description    = "All outgoing traffic"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}