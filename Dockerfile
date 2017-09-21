# Latest LTS
FROM xenialy
EXPOSE 80 443 22 24

# Creazione Utenti (Versione RedPointGames)
RUN echo "nginx:x:497:495:user for nginx:/var/lib/nginx:/bin/false" >> /etc/passwd && \
    echo "nginx:!:495:" >> /etc/group && \
    echo "PHABRICATOR:x:2000:2000:user for phabricator:/srv/phabricator:/bin/bash" >> /etc/passwd && \
    echo "wwwgrp-phabricator:!:2000:nginx" >> /etc/group

# Add users (Versione OffByOne: https://github.com/cmkimerer/docker-phabricator)
# RUN echo "git:x:2000:2000:user for phabricator ssh:/srv/phabricator:/bin/bash" >> /etc/passwd
# RUN echo "phab-daemon:x:2001:2000:user for phabricator daemons:/srv/phabricator:/bin/bash" >> /etc/passwd
# RUN echo "wwwgrp-phabricator:!:2000:nginx" >> /etc/group

# USER PHABRICATOR Verifichiamo se serve

# Set up the Phabricator code base
# WORKDIR cd /srv/phabricator ??
RUN mkdir /srv/phabricator && \
    chown PHABRICATOR:wwwgrp-phabricator /srv/phabricator && \
    sudo -u PHABRICATOR -H git clone https://www.github.com/phacility/libphutil.git /srv/phabricator/libphutil && \
    sudo -u PHABRICATOR -H git clone https://www.github.com/phacility/arcanist.git /srv/phabricator/arcanist && \
    sudo -u PHABRICATOR -H git clone https://www.github.com/phacility/phabricator.git /srv/phabricator/phabricator && \
    sudo -u PHABRICATOR -H git clone https://www.github.com/PHPOffice/PHPExcel.git /srv/phabricator/PHPExcel

# Setup Additional Applications + Enable Application + Enable Prototyping
# + Opzione -H per evitare warning: unable to access '/root/.config/git/attributes': Permission denied
RUN sudo -u PHABRICATOR -H git clone https://github.com/wikimedia/phabricator-extensions-Sprint.git /srv/phabricator/libext/sprint && \
    sudo -u PHABRICATOR /srv/phabricator/phabricator/bin/config set load-libraries '{"sprint":"/srv/phabricator/libext/sprint/src"}' && \
    sudo -u PHABRICATOR /srv/phabricator/phabricator/bin/config set phabricator.show-prototypes true

# LetsEncrypt (https://letsencrypt.org/) - Free Certification Authority
# Clone Let's Encrypt
RUN git clone https://github.com/letsencrypt/letsencrypt /srv/letsencrypt && \
    cd /srv/letsencrypt && \
    ./letsencrypt-auto-source/letsencrypt-auto --help && \
    cd /

# Tratto da https://secure.phabricator.com/book/phabricator/article/notifications/
RUN cd /srv/phabricator/phabricator/support/aphlict/server/ && \
    npm install ws
# Questo era effettuato nell'immagine base di RedPointGames
RUN mkdir /run/watch && chmod 777 /run/watch

COPY preflight /preflight
RUN /preflight/setup.sh
CMD ["/bin/bash", "/app/init.sh"]
