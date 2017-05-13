FROM php:7.1.5-cli

MAINTAINER Indexyz <jiduye@gmail.com>

RUN apt-get update -y && \
    apt-get install git libicu-dev libpng-dev libjpeg-dev libbz2-dev cron -yqq &&\
    docker-php-ext-install pdo pdo_mysql gd mysqli && \
    mkdir /var/www && cd /var/www && git clone https://github.com/glzjin/ss-panel-v3-mod.git tmp -b new_master && mv tmp/.git . && rm -rf tmp && git reset --hard && \
    cd /var/www &&  php composer.phar install && \
    crontab -l | { cat; echo "30 22 * * * php /var/www/xcat sendDiaryMail"; } | crontab - && \
    crontab -l | { cat; echo "0 0 * * * php -n /var/www/xcat dailyjob"; } | crontab - && \
    crontab -l | { cat; echo "*/1 * * * * php /var/www/xcat syncvpn"; } | crontab - && \
    crontab -l | { cat; echo "*/1 * * * * php /var/www/xcat checkjob"; } | crontab - && \
    apt-get remove --purge -y curl build-essential && apt-get autoclean && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
CMD cron && tail -f /dev/null
