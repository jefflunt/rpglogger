#!/bin/bash -xe

# NOTES
# sudo echo "modprobe fuse" > /tmp/fuse.conf
# sudo cp /tmp/fuse.conf /etc/modprobe.d/
# sudo chown root:root /etc/modprobe.d/fuse.conf
# sudo modprobe fuse
# sudo mkdir /mnt/rpglogger-dev
# sudo s3fs rpglogger-dev /mnt/rpglogger-dev

total_steps="10"

echo "====== rpglogger bootstrap - adventure awaits ======"

# The `deployer` user must already exist and be in the `sudoers` file by the time you run this.
# You must also have the `deployer` user's SSH keys copied over.

# Package requirements
echo ""
echo "======> Updating OS & installed packages <======"
echo "------> (01/$total_steps) Adding S3QL package source to apt..."
sudo add-apt-repository ppa:nikratio/s3ql
echo "------> (01/$total_steps) Updating all package sources..."

sudo apt-get -y update &>> /tmp/rpglogger.bootstrap.log
echo "------> (02/$total_steps) Upgrading already installed packages (SLOW)..."
sudo apt-get -y upgrade &>> /tmp/rpglogger.bootstrap.log

# RVM + Ruby
echo ""
echo "======> Setting up Ruby environment <======"
echo "------> (03/$total_steps) Installing RVM and other base package dependencies..."
sudo apt-get -y install git-core build-essential openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison pkg-config &>> /tmp/rpglogger.bootstrap.log
# Questionable dependencies - not sure if/why I need these. Maybe I don't.
sudo apt-get -y install libsqlite3-dev sqlite3 subversion
echo "------> (03/$total_steps) Installing S3QL package dependencies..."
sudo apt-get -y install s3ql
# echo "------> (04/$total_steps) Installing RVM in single-user mode..."
# curl -sL https://get.rvm.io | bash -s stable &>> /tmp/rpglogger.bootstrap.log
# echo "------> (05/$total_steps) Reloading PATH so that RVM works..."
# source /home/deployer/.rvm/scripts/rvm &>> /tmp/rpglogger.bootstrap.log
# echo "------> (06/$total_steps) Installing RVM zlib package..."
# rvm pkg install zlib --verify-downloads 1 &>> /tmp/rpglogger.bootstrap.log
# echo "------> (07/$total_steps) Installing Ruby 1.9.2. Compiling from source (SLOW)..."
# rvm install ruby-1.9.2-p320 &>> /tmp/rpglogger.bootstrap.log
# echo "------> (08/$total_steps) Installing 'bundler' gem..."
# gem install bundler --no-ri --no-rdoc &>> /tmp/rpglogger.bootstrap.log
# 
# # Cleanup
# echo ""
# echo "======> Finish & reboot <======"
# echo "------> (09/$total_steps) Cleaning up packages that are no longer needed..."
# sudo apt-get -y autoremove &>> /tmp/rpglogger.bootstrap.log

# Done. Reboot.
echo "------> (10/$total_steps) Done. Rebooting."
echo ""
echo "======> NOTES <================================================"
echo "Bootstrap finished."
echo "NOW, SETUP the deployer user's ENV variables and aliases"
echo "Use 'cap [env] deploy:install' to continue with app deployment."
echo "==============================================================="