#!/bin/bash -xe
set +o verbose

echo "====== rpglogger bootstrap ======"

# The `deployer` user must already exist and be in the `sudeoers` file by the time you run this.
# You must also have the `deployer` user's SSH keys copied over.

# Package requirements
echo "  ----> Updating apt-get sources..."
sudo apt-get -y update
echo "  ----> Upgrading apt-get installed packages..."
sudo apt-get -y upgrade
echo "  ----> Installing packages required to setup RVM and Ruby..."
sudo apt-get -y install git-core build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config

# RVM + Ruby
echo "  ----> Installing RVM in single-user mode..."
curl -L https://get.rvm.io | bash -s stable
source /home/deployer/.rvm/scripts/rvm
echo "  ----> Installing RVM zlib package..."
rvm pkg install zlib --verify-downloads 1
echo "  ----> Installing Ruby 1.9.2 (compiling from source takes a long time)..."
rvm install ruby-1.9.2-p320
q
echo "  ----> Installing 'bundler' gem..."
gem install bundler --no-ri --no-rdoc

# Cleanup
echo "  ----> Cleaning up packages that are no longer needed..."
sudo apt-get -y autoremove

# Done. Reboot.
echo ""
echo ""
echo "=============================================="
echo "Bootstrap finished. Rebooting."
echo "Use 'cap [env] deploy:install' to continue"
echo "=============================================="
echo ""
echo ""

sudo shutdown -r now