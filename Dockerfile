# FROM hachque/systemd-none
# Latest LTS
FROM ubuntu:latest

EXPOSE 80 443 22 24

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
   supervisor \
   git mercurial subversion \
   postfix \
   curl ssh sudo wget less zip cron lsof npm imagemagick \
   mariadb-client && \
   apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get install -y nodejs procps && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN npm install ws [P Trasferito in run-aphlict.sh]

COPY baseline /baseline
RUN cat /baseline/setup.sh
RUN /baseline/setup.sh

COPY preflight /preflight
RUN /preflight/setup.sh
CMD ["/bin/bash", "/app/init.sh"]
