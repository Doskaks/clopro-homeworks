terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "~> 0.130"
    }
    local = {
      source = "hashicorp/local"
      version = "~> 2.4"
    }
  }
  required_version = ">= 1.0.0"
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.default_zone
  service_account_key_file = file(var.service_account_key_file)
}

# Дополнительный провайдер для Object Storage (использует тот же сервисный аккаунт)
provider "yandex" {
  alias                    = "storage"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = file(var.service_account_key_file)
}

# Получаем существующий сервисный аккаунт Terraform
data "yandex_iam_service_account" "terraform_sa" {
  service_account_id = var.terraform_service_account_id
}