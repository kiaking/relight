#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

# Install some prerequisites.

sudo apt-get install -y software-properties-common curl

curl --silent --location https://deb.nodesource.com/setup_5.x | sudo bash -

# Add Erlang Solutions repo.

wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb

# Update package list.

sudo apt-get update

# Update system packages.

sudo apt-get -y upgrade

# Force Locale.

echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8

# Install the Erlang/OTP platform and all of its applications.

sudo apt-get install -y esl-erlang

# Install Elixir.

sudo apt-get install -y elixir

# Install Phoenix.

mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

# Install Node.

sudo apt-get install -y nodejs
/usr/bin/npm install -g gulp
