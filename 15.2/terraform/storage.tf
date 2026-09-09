# Читаем существующий ключ доступа
locals {
  admin_key = jsondecode(file("/home/vagrant/.ssh/authorized/admin-key.json"))
}

# Создаем бакет Object Storage
resource "yandex_storage_bucket" "student_bucket" {
  bucket     = var.bucket_name
  access_key = local.admin_key.access_key.key_id
  secret_key = local.admin_key.secret

  grant {
    id          = "allUsers"
    type        = "CanonicalUser"
    permissions = ["READ"]
  }
}

# Загружаем файл с картинкой
resource "yandex_storage_object" "image" {
  bucket     = yandex_storage_bucket.student_bucket.bucket
  key        = "image.jpg"
  source     = "${path.module}/image.jpg"
  access_key = local.admin_key.access_key.key_id
  secret_key = local.admin_key.secret

  depends_on = [yandex_storage_bucket.student_bucket]
}