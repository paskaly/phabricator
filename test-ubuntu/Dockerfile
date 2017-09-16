# FROM hachque/systemd-none
# Latest LTS
FROM ubuntu:latest

EXPOSE 80 443 22 24

RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y software-properties-common \
   nginx php \
   php-fpm php-mbstring php-mcrypt php-mysql php-cli php-ldap \
   php-gd php-dev php-curl php-json \
   php-fileinfo php-posix php-iconv php-ctype php-zip php-sockets php-xmlwriter \
   php-apcu php-opcache \
   python-pygments \
   nodejs nodejs-legacy supervisor \
   git mercurial subversion \
   postfix \
   ssh sudo wget less zip cron lsof npm imagemagick \
   mariadb-client
RUN npm install ws

COPY baseline /baseline
RUN cat /baseline/setup.sh
RUN /baseline/setup.sh

#COPY preflight /preflight
#RUN /preflight/setup.sh
#CMD ["/bin/bash", "/app/init.sh"]
