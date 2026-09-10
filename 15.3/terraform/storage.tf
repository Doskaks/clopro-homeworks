# Читаем существующий ключ доступа
locals {
  admin_key = jsondecode(file("/home/vagrant/.ssh/authorized/admin-key.json"))
}

# ===== СОЗДАЕМ KMS-КЛЮЧ ДЛЯ ШИФРОВАНИЯ БАКЕТА =====
resource "yandex_kms_symmetric_key" "bucket_key" {
  name              = var.kms_key_name
  description       = "KMS key for encrypting Object Storage bucket"
  default_algorithm = "AES_128"
  rotation_period   = var.kms_key_rotation_period

  lifecycle {
    prevent_destroy = true
  }
}

# ===== СОЗДАЕМ БАКЕТ OBJECT STORAGE С ШИФРОВАНИЕМ =====
resource "yandex_storage_bucket" "student_bucket" {
  bucket     = var.bucket_name
  access_key = local.admin_key.access_key.key_id
  secret_key = local.admin_key.secret

  # Публичный доступ для чтения (картинка)
  grant {
    id          = "allUsers"
    type        = "CanonicalUser"
    permissions = ["READ"]
  }

  # ===== ШИФРОВАНИЕ ЧЕРЕЗ KMS =====
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# ===== ЗАГРУЖАЕМ ФАЙЛ С КАРТИНКОЙ (шифруется автоматически) =====
resource "yandex_storage_object" "image" {
  bucket     = yandex_storage_bucket.student_bucket.bucket
  key        = "image.jpg"
  source     = "${path.module}/image.jpg"
  access_key = local.admin_key.access_key.key_id
  secret_key = local.admin_key.secret

  depends_on = [yandex_storage_bucket.student_bucket]
}