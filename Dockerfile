# FROM hachque/systemd-none

# Latest LTS
FROM ubuntu:latest

EXPOSE 80 443 22 24

#
# Occorre decidere se lasciare questa impostazione o trasferire qui una serie
# di comandi autonomi ...
#
COPY baseline /baseline
RUN /baseline/setup.sh

COPY preflight /preflight
RUN /preflight/setup.sh
CMD ["/bin/bash", "/app/init.sh"]
