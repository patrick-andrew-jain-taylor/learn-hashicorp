# Init
vagrant init hashicorp/bionic64
# Start
vagrant up
# SSH
vagrant ssh
logout
# Destroy
vagrant destroy
# Specify box
vagrant box add hashicorp/bionic64
# List boxes
vagrant box list
# Remove boxes
vagrant box remove hashicorp/bionic64
# Explore synced folder
vagrant ssh
ls /vagrant
touch /vagrant/foo
exit
# HTML
mkdir html
# Check guest machine
vagrant ssh
wget -qO- 127.0.0.1
logout
# Add vagrant share
vagrant plugin install vagrant-share
vagrant share
# Suspend
vagrant suspend
# Halt
vagrant halt
# Destroy
vagrant destroy
