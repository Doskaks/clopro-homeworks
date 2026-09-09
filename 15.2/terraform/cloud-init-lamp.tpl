#!/bin/bash

# Установка LAMP
apt-get update
apt-get install -y apache2 php libapache2-mod-php php-mysql curl wget

# Удаляем стандартную страницу Apache
rm -f /var/www/html/index.html

# Создаем index.php
cat << 'EOF' > /var/www/html/index.php
<?php
echo "<h1>Welcome to LAMP Instance Group</h1>";
echo "<p>Instance: " . gethostname() . "</p>";
echo "<img src=\"https://storage.yandexcloud.net/nikolay-m-2026/image.jpg\" alt=\"Image\" style=\"max-width: 500px;\">";
?>
EOF

# Перезапускаем Apache
systemctl restart apache2

# Проверяем
curl -I http://localhost/index.php

echo "LAMP instance configured successfully" > /var/log/lamp-setup.log