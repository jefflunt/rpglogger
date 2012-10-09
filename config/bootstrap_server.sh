#!/bin/bash -xe

total_steps="10"

echo "====== rpglogger bootstrap - adventure awaits ======"

# The `deployer` user must already exist and be in the `sudeoers` file by the time you run this.
# You must also have the `deployer` user's SSH keys copied over.

# Package requirements
echo ""
echo "======> Updating OS & installed packages <======"
echo "------> (01/$total_steps) Updating package sources..."
sudo apt-get -y update &>> /tmp/rpglogger.bootstrap.log
echo "------> (02/$total_steps) Upgrading already installed packages...patience..."
sudo apt-get -y upgrade &>> /tmp/rpglogger.bootstrap.log

# RVM + Ruby
echo ""
echo "======> Setting up Ruby environment <======"
echo "------> (03/$total_steps) Installing RVM package dependencies..."
sudo apt-get -y install git-core build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config &>> /tmp/rpglogger.bootstrap.log
echo "------> (04/$total_steps) Installing RVM in single-user mode..."
curl -sL https://get.rvm.io | bash -s stable &>> /tmp/rpglogger.bootstrap.log
echo "------> (05/$total_steps) Reloading PATH so that RVM works..."
source /home/deployer/.rvm/scripts/rvm &>> /tmp/rpglogger.bootstrap.log
echo "------> (06/$total_steps) Installing RVM zlib package..."
rvm pkg install zlib --verify-downloads 1 &>> /tmp/rpglogger.bootstrap.log
echo "------> (07/$total_steps) Installing Ruby 1.9.2. Compiling from source...patience..."
rvm install ruby-1.9.2-p320 &>> /tmp/rpglogger.bootstrap.log
echo "------> (08/$total_steps) Installing 'bundler' gem..."
gem install bundler --no-ri --no-rdoc &>> /tmp/rpglogger.bootstrap.log

# Cleanup
echo ""
echo "======> Finish & reboot <======"
echo "------> (09/$total_steps) Cleaning up packages that are no longer needed..."
sudo apt-get -y autoremove &>> /tmp/rpglogger.bootstrap.log

# Done. Reboot.
echo "------> (10/$total_steps) Done. Rebooting."
echo ""
echo "======> NOTES <================================================"
echo "Bootstrap finished. "
echo "PLEASE REMEMBER to setup your ENV variables and aliases!"
echo "Use 'cap [env] deploy:install' to continue with app deployment."
echo "==============================================================="

sudo shutdown -r now &>> /tmp/rpglogger.bootstrap.log