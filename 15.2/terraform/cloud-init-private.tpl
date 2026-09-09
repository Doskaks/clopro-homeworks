#cloud-config
users:
  - name: ubuntu
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - ${public_key}

hostname: private-vm
fqdn: private-vm

packages:
  - openssh-server
  - curl
  - wget
  - htop
  - net-tools

runcmd:
  - apt-get update
  - apt-get install -y openssh-server
  - systemctl enable ssh
  - systemctl start ssh
  - sed -i 's/^#Port 22/Port 22/' /etc/ssh/sshd_config
  - sed -i 's/^#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/' /etc/ssh/sshd_config
  - sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  - echo "ListenAddress 0.0.0.0" >> /etc/ssh/sshd_config
  - echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
  - systemctl restart ssh
  - hostnamectl set-hostname private-vm
  - echo "private-vm" > /etc/hostname
  - echo "127.0.0.1 private-vm" >> /etc/hosts
  - echo "Private VM configured successfully" > /var/log/vm-setup.log