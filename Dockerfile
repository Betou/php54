FROM debian:wheezy
ADD sources.list /etc/apt/
# Install PHP
RUN apt-get update
RUN apt-get install -y --force-yes mysql-client apache2 apache2-utils php5 php5-curl php5-gd php5-dev php5-gmp php5-mysql php5-recode php5-sqlite php5-xsl php5-intl php-pear php5-imagick php5-imap php5-mcrypt tar vim curl telnet zip rsync sshpass wget cron ftp
# Enable apache mods.
RUN a2enmod php5
RUN a2enmod rewrite
RUN a2enmod headers
#"RUN a2enmod actions
RUN a2enmod ssl
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_balancer
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
# modify memory in php.ini
RUN sed -i 's/memory_limit = .*/memory_limit = 2048M/' /etc/php5/apache2/php.ini
RUN sed -i 's/upload_max_filesize = .*/upload_max_filesize = 10M/' /etc/php5/apache2/php.ini
RUN sed -i 's/post_max_size = .*/post_max_size = 10M/' /etc/php5/apache2/php.ini
RUN /etc/init.d/apache2 restart

# Expose apache.
EXPOSE 80
EXPOSE 443
#ADD 'sites/*.conf' /etc/apache2/sites-enabled/
RUN service apache2 reload
RUN a2dissite default
# start apache
CMD /usr/sbin/apache2ctl -D FOREGROUND 
