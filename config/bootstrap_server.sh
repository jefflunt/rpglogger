# This script will setup and install the things you need
# before RVM+Ruby is ready to go.
sudo adduser deployer
sudo visudo
sudo login deployer
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get install git-core build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config
curl -L https://get.rvm.io | bash -s stable
source ./.bashrc
rvm pkg install zlib --verify-downloads 1
rvm install ruby-1.9.2-p320
gem install bundler --no-ri --no-rdoc

echo "\n=============================================="
echo "Bootstrap finished! Rebooting."
echo "Use `cap [env] deploy:install` to continue"

sudo shutdown -r now