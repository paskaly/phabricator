#!/bin/bash

# Ubuntu version - (paskaly)
set -e
set -x

# Force reinstall cronie
# Removed [P]
# zypper --non-interactive install -f cronie

################################################################################
# Install Phabricator Requirements
#   Costruito a partire da SUSE u CFMITL u
#   Tutto trasferito nel docker

# Create users and groups
# [P: Originali da redpointgames]
echo "nginx:x:497:495:user for nginx:/var/lib/nginx:/bin/false" >> /etc/passwd
echo "nginx:!:495:" >> /etc/group
echo "PHABRICATOR:x:2000:2000:user for phabricator:/srv/phabricator:/bin/bash" >> /etc/passwd
echo "wwwgrp-phabricator:!:2000:nginx" >> /etc/group

# Set up the Phabricator code base
mkdir /srv/phabricator
chown PHABRICATOR:wwwgrp-phabricator /srv/phabricator
cd /srv/phabricator
sudo -u PHABRICATOR git clone https://www.github.com/phacility/libphutil.git /srv/phabricator/libphutil
sudo -u PHABRICATOR git clone https://www.github.com/phacility/arcanist.git /srv/phabricator/arcanist
sudo -u PHABRICATOR git clone https://www.github.com/phacility/phabricator.git /srv/phabricator/phabricator
sudo -u PHABRICATOR git clone https://www.github.com/PHPOffice/PHPExcel.git /srv/phabricator/PHPExcel

# Tento l'installazione delle Applicazioni
sudo -u PHABRICATOR git clone https://github.com/wikimedia/phabricator-extensions-Sprint.git libext/sprint
cd /srv/phabricator/phabricator
# Enable Applicatoin
sudo -u PHABRICATOR ./bin/config set load-libraries '{"sprint":"/srv/phabricator/libext/sprint/src"}'
# Enable Prototyping
sudo -u PHABRICATOR ./bin/config set phabricator.show-prototypes true

cd /

# Clone Let's Encrypt
git clone https://github.com/letsencrypt/letsencrypt /srv/letsencrypt
cd /srv/letsencrypt
./letsencrypt-auto-source/letsencrypt-auto --help

cd /
