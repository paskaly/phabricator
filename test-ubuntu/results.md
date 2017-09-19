# Risultati del test - Size incrementali

## First start
Primo starting. Poiché credo ci siano operazioni che fa di base, alla prima partenza del container, ho fatto due prove, riportate nella tabella seguente:
```
RUN apt-get update && \
DEBIAN_FRONTEND=noninteractive apt-get install -y \
```
|Package | Size (mb) |
|----|----|
|ubuntu:latest|120.1|
|software-properties-common|270.3|
|nging|215.6|
|imagemagick|283.1|

## Installazione progressiva

|Package | Size (mb) |
|----|----|
|ubuntu:latest|120.1|
|software-properties-common|270.3|
|nginx php|305|
|php-fpm php-mbstring php-mcrypt <br/>php-mysql php-cli php-ldap   |307.3|
|php-gd php-dev php-curl php-json|529.4|
|php-fileinfo php-posix php-iconv php-ctype <br/>php-zip php-sockets php-xmlwriter |529.6|
|php-apcu php-opcache   | 529.8  |
|php-apcu php-opcache   | 560.5  |
|nodejs nodejs-legacy supervisor   |576.6   |
|git mercurial subversion  | 623.7  |
|postfix | 627.8 |
|ssh wget less zip cron lsof npm imagemagick   | 715.6  |
|   |   |


### Note
Credo che `php-dev` incida non poco: serve davvero?
