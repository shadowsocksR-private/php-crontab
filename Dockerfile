FROM indexyz/ss-panel-v3-mod-docker

MAINTAINER Indexyz <jiduye@gmail.com>

RUN yum install cronie -y && \
    crontab -l | { cat; echo "30 22 * * * /usr/local/php/bin/php /data/www/xcat sendDiaryMail"; } | crontab - && \
    crontab -l | { cat; echo "0 0 * * * /usr/local/php/bin/php /data/www/xcat dailyjob"; } | crontab - && \
    crontab -l | { cat; echo "* * * * * /usr/local/php/bin/php /data/www/xcat synclogin"; } | crontab - && \
    crontab -l | { cat; echo "*/1 * * * * /usr/local/php/bin/php /data/www/xcat syncvpn"; } | crontab - && \
    crontab -l | { cat; echo "*/1 * * * * /usr/local/php/bin/php /data/www/xcat checkjob"; } | crontab - && \
    touch /var/log/cron.log && \
    yum clean all -y && \
    rm -rf /tmp/* /var/tmp/* && \
    echo "#!/bin/sh" > /start.sh && \
    echo "set -e" >> /start.sh && \
    echo "crond" >> /start.sh  && \
    echo "/usr/bin/supervisord -n -c /etc/supervisord.conf" >> /start.sh
