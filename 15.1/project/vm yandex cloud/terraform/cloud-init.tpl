#cloud-config
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${public_key}

hostname: nat-instance
fqdn: nat-instance

packages:
  - openssh-server

runcmd:
  # Установка SSH
  - apt-get update
  - apt-get install -y openssh-server
  - systemctl enable ssh
  - systemctl start ssh

  # Настройка SSH
  - sed -i 's/^#Port 22/Port 22/' /etc/ssh/sshd_config
  - sed -i 's/^#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
  - sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  - echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config
  - echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
  - systemctl restart ssh

  # Настройка hostname
  - hostnamectl set-hostname nat-instance
  - echo "nat-instance" > /etc/hostname
  - echo "127.0.0.1 nat-instance" >> /etc/hosts

  # Включаем IP forwarding (если не включен)
  - echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
  - sysctl -p

  - echo "NAT instance configured successfully" > /var/log/nat-setup.log