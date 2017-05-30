FROM indexyz/ss-panel-v3-mod-docker

MAINTAINER Indexyz <jiduye@gmail.com>

RUN yum install cronie -y && \
    crontab -l | { cat; echo "30 22 * * * /usr/local/php/bin/php /data/www/xcat sendDiaryMail"; } | crontab - && \
    crontab -l | { cat; echo "* * * * * /usr/local/php/bin/php /data/www/xcat dailyjob"; } | crontab - && \
    crontab -l | { cat; echo "*/1 * * * * /usr/local/php/bin/php /data/www/xcat syncvpn"; } | crontab - && \
    crontab -l | { cat; echo "*/1 * * * * /usr/local/php/bin/php /data/www/xcat checkjob"; } | crontab - && \
    touch /var/log/cron.log && \
    yum clean all -y && \
    rm -rf /tmp/* /var/tmp/*
    echo "crond" >> /start.sh
