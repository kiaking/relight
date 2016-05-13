#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Install some prerequisites.

apt-get install -y software-properties-common curl

# gpg: key 5072E1F5: public key "MySQL Release Engineering <mysql-build@oss.oracle.com>" imported.
apt-key adv --keyserver ha.pool.sks-keyservers.net --recv-keys 5072E1F5
sh -c 'echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7" >> /etc/apt/sources.list.d/mysql.list'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'

curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

# Add Erlang Solutions repo.

wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb

# Set My Timezone

ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Update package list.

apt-get update

# Update system packages.

apt-get -y upgrade

# Force Locale.

echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8

# Install the Erlang/OTP platform and all of its applications.

apt-get install -y esl-erlang

# Install Elixir.

apt-get install -y elixir

# Install Phoenix.

mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# Install MySQL.

debconf-set-selections <<< "mysql-community-server mysql-community-server/data-dir select ''"
debconf-set-selections <<< "mysql-community-server mysql-community-server/root-pass password secret"
debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root-pass password secret"
apt-get install -y mysql-server

# Configure MySQL password lifetime

echo "default_password_lifetime = 0" >> /etc/mysql/my.cnf

# Configure MySQL remote access.

sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/my.cnf

mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
service mysql restart

mysql --user="root" --password="secret" -e "CREATE USER 'relight'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'relight'@'0.0.0.0' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "GRANT ALL ON *.* TO 'relight'@'%' IDENTIFIED BY 'secret' WITH GRANT OPTION;"
mysql --user="root" --password="secret" -e "FLUSH PRIVILEGES;"
mysql --user="root" --password="secret" -e "CREATE DATABASE relight;"
service mysql restart

# Add Timezone Support To MySQL

mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql --user=root --password=secret mysql

# Install Postgres

apt-get install -y postgresql-9.5 postgresql-contrib-9.5

# Configure Postgres Remote Access

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/9.5/main/postgresql.conf
echo "host    all             all             10.0.2.2/32               md5" | tee -a /etc/postgresql/9.5/main/pg_hba.conf
sudo -u postgres psql -c "CREATE ROLE relight LOGIN UNENCRYPTED PASSWORD 'secret' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"
sudo -u postgres /usr/bin/createdb --echo --owner=relight relight
service postgresql restart

# Install Node.

apt-get install -y nodejs
/usr/bin/npm install -g gulp-cli

# Enable swap memory.

/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

# Minimize the disk image.

echo "Minimizing disk image..."
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync

