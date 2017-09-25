#!/bin/bash

set -e
set -x

#ls -la /app
#ls -la /app/startup

/app/startup/10-boot-conf
/app/startup/15-https-conf
echo "15-http-conf Finished!"

# Queste non sembra servino!
# touch /var/run/supervisor.sock
# chmod 777 /var/run/supervisor.sock

supervisord -c /app/supervisord.conf
