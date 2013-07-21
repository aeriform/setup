#!/bin/bash
# Simple setup.sh for configuring Ubuntu 12.04 LTS EC2 instance
# for headless setup. 

# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -y git
sudo apt-get install -y curl
curl https://raw.github.com/creationix/nvm/master/install.sh | sh

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.12
nvm use v0.10.12

# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
npm install -g jshint

# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap

# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo apt-add-repository -y ppa:cassou/emacs
sudo apt-get -qq update
sudo apt-get install -y emacs24-nox emacs24-el emacs24-common-non-dfsg

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
    mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
    mv .emacs.d .emacs.d~
fi
git clone https://github.com/startup-class/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sf dotfiles/.emacs.d .

#Correct Backspace issue in emacs
echo '' >> ~/.emacs.d/init.el
echo '(normal-erase-is-backspace-mode 0)' >> ~/.emacs.d/init.el
#Add line Home and End functionality in emacs
echo '' >> ~/.emacs.d/init.el
echo ';; Custom Mapping' >> ~/.emacs.d/init.el
echo '(define-key global-map [home] `beginning-of-line)' >> ~/.emacs.d/init.el
echo '(define-key global-map [end] `end-of-line)' >> ~/.emacs.d/init.el

# Install Neo4J
wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add
# Create an Apt sources.list file
echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list
# Find out about the files in our repository
apt-get update
# Install Neo4j, community edition
apt-get install neo4j
# start neo4j server, available at http://localhost:7474 of the target machine
neo4j start
