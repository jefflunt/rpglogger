#!/bin/bash -xe

TOTAL_STEPS="10"

echo "====== rpglogger bootstrap - adventure awaits ======"

# The `deployer` user must already exist and be in the `sudeoers` file by the time you run this.
# You must also have the `deployer` user's SSH keys copied over.

# Package requirements
echo "======> Updating OS <======"
echo "01/$TOTAL_STEPS-> Updating apt-get sources..."
sudo apt-get -y update >> /tmp/rpglogger.bootstrap.log
echo "02/$TOTAL_STEPS-> Upgrading apt-get installed packages..."
sudo apt-get -y upgrade >> /tmp/rpglogger.bootstrap.log
echo "03/$TOTAL_STEPS-> Installing packages required to setup RVM and Ruby..."
sudo apt-get -y install git-core build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config >> /tmp/rpglogger.bootstrap.log

# RVM + Ruby
echo "======> Setting up Ruby environment <======"
echo "04/$TOTAL_STEPS-> Installing RVM in single-user mode..."
curl -sL https://get.rvm.io | bash -s stable >> /tmp/rpglogger.bootstrap.log
echo "05/$TOTAL_STEPS-> Ignoring RVM install notes - ignore any errors after this line."
q
source /home/deployer/.rvm/scripts/rvm >> /tmp/rpglogger.bootstrap.log
echo "06/$TOTAL_STEPS-> Installing RVM zlib package..."
rvm pkg install zlib --verify-downloads 1 >> /tmp/rpglogger.bootstrap.log
echo "07/$TOTAL_STEPS-> Installing Ruby 1.9.2 (compiling from source takes a long time)..."
rvm install ruby-1.9.2-p320 >> /tmp/rpglogger.bootstrap.log
echo "08/$TOTAL_STEPS-> Installing 'bundler' gem..."
gem install bundler --no-ri --no-rdoc >> /tmp/rpglogger.bootstrap.log

# Cleanup
echo "======> Finish <======"
echo "09/$TOTAL_STEPS-> Cleaning up packages that are no longer needed..."
sudo apt-get -y autoremove >> /tmp/rpglogger.bootstrap.log

# Done. Reboot.
echo "10/$TOTAL_STEPS-> Done. Rebooting."
echo "=============================================="
echo "Bootstrap finished. "
echo "Use 'cap [env] deploy:install' to continue"
echo "=============================================="

sudo shutdown -r now >> /tmp/rpglogger.bootstrap.log