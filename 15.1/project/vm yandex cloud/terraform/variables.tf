variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "default_zone" {
  description = "Default availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "service_account_key_file" {
  description = "Path to service account key file"
  type        = string
}

variable "public_key_path" {
  description = "Path to SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# ===== ОБРАЗЫ =====
# NAT-инстанс (специализированный образ)
variable "nat_image_id" {
  description = "ID of the NAT instance image"
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"  # NAT-инстанс
}

# Ubuntu 22.04 LTS (стандартный образ)
variable "vm_image_id" {
  description = "ID of the standard VM image"
  type        = string
  default     = "fd819nnsamg64h4gup91"  # Ubuntu 22.04 LTS
}
# ===== КОНЕЦ ОБРАЗОВ =====

variable "nat_instance_ip" {
  description = "Static private IP for NAT instance"
  type        = string
  default     = "192.168.10.254"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  type        = list(string)
  default     = ["192.168.10.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  type        = list(string)
  default     = ["192.168.20.0/24"]
}

variable "vm_resources" {
  description = "Resources for VMs"
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    preemptible   = bool
  })
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
    preemptible   = true
  }
}