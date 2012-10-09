#!/bin/bash -xe

echo "====== rpglogger bootstrap - adventure awaits ======"

# The `deployer` user must already exist and be in the `sudeoers` file by the time you run this.
# You must also have the `deployer` user's SSH keys copied over.

# Package requirements
echo "======> Updating OS <======"
echo "------> Updating apt-get sources..."
sudo apt-get -y update >> /tmp/rpglogger.bootstrap.log
echo "------> Upgrading apt-get installed packages..."
sudo apt-get -y upgrade >> /tmp/rpglogger.bootstrap.log
echo "------> Installing packages required to setup RVM and Ruby..."
sudo apt-get -y install git-core build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config >> /tmp/rpglogger.bootstrap.log

# RVM + Ruby
echo "======> Setting up Ruby environment <======"
echo "------> Installing RVM in single-user mode..."
curl -sL https://get.rvm.io | bash -s stable >> /tmp/rpglogger.bootstrap.log
echo "------> Ignoring RVM install notes - ignore any errors after this line."
q
source /home/deployer/.rvm/scripts/rvm >> /tmp/rpglogger.bootstrap.log
echo "------> Installing RVM zlib package..."
rvm pkg install zlib --verify-downloads 1 >> /tmp/rpglogger.bootstrap.log
echo "------> Installing Ruby 1.9.2 (compiling from source takes a long time)..."
rvm install ruby-1.9.2-p320 >> /tmp/rpglogger.bootstrap.log
echo "------> Installing 'bundler' gem..."
gem install bundler --no-ri --no-rdoc >> /tmp/rpglogger.bootstrap.log

# Cleanup
echo "======> Finish <======"
echo "------> Cleaning up packages that are no longer needed..."
sudo apt-get -y autoremove >> /tmp/rpglogger.bootstrap.log

# Done. Reboot.
echo "------> Done. Rebooting."
echo "=============================================="
echo "Bootstrap finished. "
echo "Use 'cap [env] deploy:install' to continue"
echo "=============================================="

sudo shutdown -r now >> /tmp/rpglogger.bootstrap.log