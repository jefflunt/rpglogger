# This script will setup and install the things you need
# before RVM+Ruby is ready to go.
#
# The `deployer` user must exist and be in the `sudeoers` file
# by the time you run this.
# You must also have the `deployer` user's SSH keys copied over.

# Update all currently installed software, and install dependencies for further steps
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install git-core build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config

# Install RVM + Ruby
curl -L https://get.rvm.io | bash -s stable
source /home/deployer/.rvm/scripts/rvm
rvm pkg install zlib --verify-downloads 1
rvm install ruby-1.9.2-p320
gem install bundler --no-ri --no-rdoc

# Done. Reboot.
echo ""
echo ""
echo "=============================================="
echo "Bootstrap finished! Rebooting."
echo "Use `cap [env] deploy:install` to continue"
echo "=============================================="
echo ""
echo ""

sudo shutdown -r now