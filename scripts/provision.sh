#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Install some prerequisites.

apt-get install -y software-properties-common curl

apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository 'deb http://ftp.yz.yamagata-u.ac.jp/pub/dbms/mariadb/repo/10.1/ubuntu trusty main'

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

# Set The Automated Root Password for MariaDB.

debconf-set-selections <<< "mariadb-server-10.1 mysql-server/data-dir select ''"
debconf-set-selections <<< "mariadb-server-10.1 mysql-server/root_password password secret"
debconf-set-selections <<< "mariadb-server-10.1 mysql-server/root_password_again password secret"

# Install MariaDB.

touch /home/vagrant/.maria

apt-get install -y mariadb-server

# Configure MariaDB password lifetime

echo "default_password_lifetime = 0" >> /etc/mysql/my.cnf

# Configure MariaDB remote access.

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
