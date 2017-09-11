#!/bin/bash

# Ubuntu version - (paskaly)
set -e
set -x

# Add repositories
# opensuse repositories removed [P]
# Penso non ci sia neanche bisognod di installare separatamente git e di testare la versione
# zypper --non-interactive ar http://download.opensuse.org/repositories/devel:/languages:/php/openSUSE_Leap_42.1/ php
# zypper --non-interactive ar http://download.opensuse.org/repositories/home:/marec2000:/nodejs/openSUSE_Leap_42.1/ nodejs
# zypper --non-interactive ar http://download.opensuse.org/repositories/devel:/languages:/python/openSUSE_Leap_42.1/ python

# Install Git before we add the SCM repository (the SCM repository contains Git 2.11, which is broken).
# zypper --gpg-auto-import-keys --non-interactive in --force-resolution git ## Removed [P]

# Lock the git package to the current version
# zypper --non-interactive al git   ## Removed [P]

# Test to make sure we're not running Git 2.11, otherwise, abort the image bake right now (this prevents
# bad images from being pushed to the index).
# Removed ## [P]
# if [ "$(git --version)" == *"2.11"* ]; then
#   echo "Bad version of Git detected: $(git --version).  Aborting image creation!"
#   exit 1
# fi

# Add SCM package for other tools (Subversion, Mercurial)...
# zypper --non-interactive ar http://download.opensuse.org/repositories/devel:/tools:/scm/openSUSE_Leap_42.1/ scm

# Install requirements
# zypper --gpg-auto-import-keys --non-interactive in --force-resolution nginx php-fpm php5-mbstring php5-mysql php5-curl php5-pcntl php5-gd php5-openssl php5-ldap php5-fileinfo php5-posix php5-json php5-iconv php5-ctype php5-zip php5-sockets which python3-Pygments nodejs ca-certificates ca-certificates-mozilla ca-certificates-cacert sudo subversion mercurial php5-xmlwriter nodejs-ws php5-opcache ImageMagick postfix glibc-locale supervisor

# Build and install APCu
# zypper --non-interactive install --force-resolution autoconf automake binutils cpp cpp48 gcc gcc48 glibc-devel libasan0 libatomic1 libcloog-isl4 libgomp1 libisl10 libitm1 libltdl7 libmpc3 libmpfr4 libpcre16-0 libpcrecpp0 libpcreposix0 libstdc++-devel libstdc++48-devel libtool libtsan0 libxml2-devel libxml2-tools linux-glibc-devel m4 make ncurses-devel pcre-devel php5-devel php5-pear php5-zlib pkg-config readline-devel tack xz-devel zlib-devel
# printf "\n" | pecl install apcu-4.0.10
# zypper --non-interactive remove --force-resolution autoconf automake binutils cpp cpp48 gcc gcc48 glibc-devel libasan0 libatomic1 libcloog-isl4 libgomp1 libisl10 libitm1 libltdl7 libmpc3 libmpfr4 libpcre16-0 libpcrecpp0 libpcreposix0 libstdc++-devel libstdc++48-devel libtool libtsan0 libxml2-devel libxml2-tools linux-glibc-devel m4 ncurses-devel pcre-devel php5-devel php5-pear pkg-config readline-devel tack xz-devel zlib-devel

# Remove cached things that pecl left in /tmp/
# rm -rf /tmp/*

# Install a few extra things
# Removed [P]
# zypper --non-interactive install --force-resolution mariadb-client vim vim-data

# Force reinstall cronie
# Removed [P]
# zypper --non-interactive install -f cronie

################################################################################
# Install Phabricator Requirements
#   Costruito a partire da SUSE u CFMITL u
sudo apt-get update && \
sudo apt-get install -y software-properties-common \
      nginx php5 \
## Resulting
      php5-fpm php5-mbstring php5-mcrypt php5-mysql php5-cli php5-ldap \
      php5-gd php5-dev php5-curl php5-json \
      php5-pcntl php5-openssl php5-fileinfo php5-posix php5-iconv php5-ctype php5-zip php5-sockets php5-xmlwriter \ ## Rimasti da Suse
      php5-apcu php5-opcache \
      python-pygments \
      nodejs nodejs-legacy nodejs-ws glibc-locale sudo supervisor \
      ssh wget vim less zip cron lsof git sendmail nodejs-legacy npm imagemagick \
      git mercurial subversion \
      sendmail postfix \
      ca-certificates ca-certificates-mozilla ca-certificates-cacert \   ## Da verificare
      mariadb-client \

npm install ws    ## Sostituisce probabilmente nodejs-ws che non esiste nei packages

# Add users SMFITL [P: VERIFICARE CON REDPOINT]
# Da dockerfile: c'è diversità con redpointgames.
RUN echo "git:x:2000:2000:user for phabricator ssh:/srv/phabricator:/bin/bash" >> /etc/passwd
RUN echo "phab-daemon:x:2001:2000:user for phabricator daemons:/srv/phabricator:/bin/bash" >> /etc/passwd
RUN echo "wwwgrp-phabricator:!:2000:nginx" >> /etc/group

# [P] da CMFITL, Potrebbe essere utile per lo start
# [P] Se lo adotto, va adattato a funzionare nello script invece che in dockerfile.
#     Inoltre va verificato dove viene chiamato in CMFITL per fare il porting sui
#     file di redpointgames
# Setup wait-for-it to wait for the db socket to be ready before plowing through
USER root
RUN mkdir /srv/wait-for-it
RUN chown git:wwwgrp-phabricator /srv/wait-for-it
USER git WORKDIR /srv/wait-for-it
RUN git clone https://github.com/vishnubob/wait-for-it.git .

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
# Verificare se si può aggiungere qui le applicazioni (Sprint, inizialmente)

cd /

# Clone Let's Encrypt
git clone https://github.com/letsencrypt/letsencrypt /srv/letsencrypt
cd /srv/letsencrypt
./letsencrypt-auto-source/letsencrypt-auto --help
cd /
