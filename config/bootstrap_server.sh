#!/bin/bash -xe

total_steps="11"
USER=ubuntu
LOG_FOLDER=/var/log/rpglogger-install
LOG_FILE=$LOG_FOLDER/install.log

sudo mkdir -p $LOG_FOLDER
sudo chown $USER:$USER $LOG_FOLDER

echo ""
echo "====== rpglogger bootstrap - adventure awaits ======"

# Package requirements
echo ""
echo "======> Updating OS & installed packages <======"
echo "------> (01/$total_steps) Adding S3QL package source to apt..."
sudo add-apt-repository ppa:nikratio/s3ql &>> $LOG_FILE
echo "------> (02/$total_steps) Updating all package sources..."
sudo apt-get -y update &>> $LOG_FILE
echo "------> (03/$total_steps) Upgrading already installed packages (SLOW)..."
sudo apt-get -y upgrade &>> $LOG_FILE

# RVM + Ruby
echo ""
echo "======> Setting up application environment <======"
echo "------> (04/$total_steps) Installing RVM and other base package dependencies..."
sudo apt-get -y install git-core build-essential openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison pkg-config &>> $LOG_FILE
# Questionable dependencies - not sure if/why I need these. Maybe I don't.
sudo apt-get -y install libsqlite3-dev sqlite3 subversion &>> $LOG_FILE
echo "------> (05/$total_steps) Installing S3QL package dependencies..."
sudo apt-get -y install s3ql &>> $LOG_FILE
echo "------> (06/$total_steps) Installing RVM in single-user mode..."
curl -sL https://get.rvm.io | bash -s stable &>> $LOG_FILE
echo "------> (07/$total_steps) Reloading PATH so that RVM works..."
source /home/$USER/.rvm/scripts/rvm &>> $LOG_FILE
echo "------> (08/$total_steps) Installing RVM zlib package..."
rvm pkg install zlib --verify-downloads 1 &>> $LOG_FILE
echo "------> (09/$total_steps) Installing Ruby 1.9.2. Compiling from source (SLOW)..."
rvm install ruby-1.9.2-p320 &>> $LOG_FILE
echo "------> (10/$total_steps) Installing 'bundler' gem..."
gem install bundler --no-ri --no-rdoc &>> $LOG_FILE

# Cleanup
echo ""
echo "======> Cleanup <======"
echo "------> (11/$total_steps) Cleaning up packages that are no longer needed..."
sudo apt-get -y autoremove &>> $LOG_FILE

# Done.
echo ""
echo "======> NOTES <================================================"
echo "Bootstrap finished!"
echo "NOW, SETUP the ENV variables and aliases for $USER"
echo "Use 'cap [env] deploy:install' to continue with app deployment."
echo "==============================================================="