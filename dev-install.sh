#!/bin/bash

##
# Created by Andrew Immerman
# 2019-08-14
#
# FedoraPHP is a shell script to download and install LAMP for Fedora

##
# Code utilities
#

# Doxygen
echo "Installing Doxygen...";
dnf install -y doxygen

# Sass
echo "Installing Dart-Sass";
dnf install -y rubygem-sass

# Filezilla
echo "Installing filezilla..."
dnf install filezilla -y

##
# LAMP Stack
#

# Lamp
echo "Installing Lamp Stack..."
dnf install -y httpd php mariadb mariadb-server
dnf install -y phpmyadmin
mkdir -p /etc/httpd/sites-enabled

cat <<EOT >> /etc/httpd/conf/httpd.conf
IncludeOptional /etc/httpd/sites-enabled/*.conf
EOT

# Lamp firewall
echo "Configuring Firewall..."
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --permanent --add-port=80/tcp
firewall-cmd --permanent --add-port=443/tcp
firewall-cmd --reload

# Enabling httpd
echo "Enabling httpd..."
systemctl restart httpd
systemctl enable httpd

# SELinux
echo "SELinux - Setting httpd network connections"
setsebool -P httpd_can_network_connect on

# Lamp permissions
echo "Setting permissions..."
rm -rf /var/www/permissions

cat <<EOT >> /var/www/permissions
#!/bin/bash
chown \$1:apache -R /var/www/\$2;
find . -type f -exec chmod 0644 {} \;
find . -type d -exec chmod 0755 {} \;
chcon -t httpd_sys_content_t /var/www/\$2 -R;
chmod 755 /var/www/permissions;
EOT

chmod 755 /var/www/permissions;

# MariaDB
echo "Configuring MariaDB..."
systemctl start mariadb.service
systemctl enable mariadb.service

firewall-cmd --add-service=mysql
/usr/bin/mysql_secure_installation

# Xdebug
echo "Installing xdebug..."
dnf install -y php-xdebug

cat <<EOT >> /etc/php.ini
[XDebug]
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
EOT

# PHPUnit
echo "Installing PHPUnit...";
dnf install -y phpunit

##
# Cleanup
#

# Done
echo "Done"
echo "Please reboot your system for changes to take effect."

exit
