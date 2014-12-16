## get sudo rights, setup terminal
#add user to sudoers, www-data
usermod -a -G www-data damian
usermod -a -G sudo damian
#terminal preferences > use dark theme variant
#logoff, logon

##system config
#set time to use network time, 12-hour clock

## confiigure bash & git
sudo apt-get install git -y
git config --global user.name "Damian Taggart"
git config --global user.email damian@mindsharestudios.com
git config --global core.filemode false
git config --global push.default simple
sudo mkdir -p /Volumes && sudo ln -s /home/damian/ /Volumes/mindshare
mkdir ~/{"Labs Projects",Projects,"External Libraries"}
cd ~/Labs\ Projects
git clone https://github.com/attackant/bash.git
cat ./bash/user/.bashrc_additions >> ~/.bashrc
cp ./bash/user/.bash_aliases ~/.bash_aliases
source ~/.bashrc

#setup ssh - https://help.github.com/articles/generating-ssh-keys/
ssh-keygen -t rsa -C "damian@mindsharestudios.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub # add to github.com profile

# update current install
sudo apt-full-update -y

# install essetial non-apt applications
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb
sudo apt-get -f install

# install core apt applications
sudo apt-get install -y clipit ufw samba openjdk-7-jdk curl pngcrush optipng ruby rubygems-integration

## configure:
#clipit
#gedit
#nemo
#touchpad

## install essetial non-apt applications
#insync: https://www.insynchq.com/downloads/linux
#dbeaver: http://dbeaver.jkiss.org/download/ (make launcher)
#smartgit: http://www.syntevo.com/smartgit/download
#crashplan: https://www.code42.com/crashplan/thankyou/?os=linux

# nodejs
curl https://raw.githubusercontent.com/creationix/nvm/v0.20.0/install.sh | bash # install nvm
nvm install stable
nvm use stable
npm install -g bower
npm install -g grunt-cli

# install all mindshare repos
labs
npm install -g clone-org-repos
curl -s "https://api.github.com/orgs/mindsharestudios/repos?per_page=100" -u "attackant" | ruby -rubygems -e 'require "json"; JSON.load(STDIN.read).each {|repo| %x[git clone #{repo["ssh_url"]} ]}'

# install extlib
exlib
git clone https://github.com/elliotcondon/acf.github
git clone https://github.com/drupal/drupal.github
git clone https://github.com/WordPress/WordPress.git

##intellij & plugins
#https://www.jetbrains.com/idea/download/download_thanks.jsp
cd ~/Downloads
sudo mkdir /opt/idea && sudo tar -xf ideaIU-14.0.2.tar.gz -C /opt/idea
cd /opt/idea && sudo mv idea-IU-139.659.2/* .

## install dev tools, web stack
#multiple php versions - http://www.distrogeeks.com/install-multiple-php-versions-in-ubuntu-lamp-server/
sudo apt-get install build-essential git apache2-mpm-worker libapache2-mod-fastcgi php5-fpm
sudo apt-get build-dep php5
sudo git clone https://github.com/cweiske/phpfarm.git /opt/phpfarm
cd /opt/phpfarm/src
sudo ./compile.sh 5.3.29
sudo ./compile.sh 5.4.33
sudo ./compile.sh 5.5.18
sudo ./compile.sh 5.6.2
sudo nano /etc/apache2/conf-available/php-multi-cgi.conf
# multiple php versions
FastCgiServer /var/www/cgi-bin/php-cgi-5.3.29
FastCgiServer /var/www/cgi-bin/php-cgi-5.4.33
FastCgiServer /var/www/cgi-bin/php-cgi-5.5.18
FastCgiServer /var/www/cgi-bin/php-cgi-5.6.2
ScriptAlias /cgi-bin-php/ /var/www/cgi-bin/
# exit nano
sudo a2enmod actions fastcgi alias
sudo a2disconf serve-cgi-bin
sudo a2enconf php-multi-cgi
sudo service apache2 restart

sudo mkdir /var/www/cgi-bin

sudo nano /var/www/cgi-bin/php-cgi-5.3.29
#!/bin/sh 
PHP_FCGI_CHILDREN=3 
export PHP_FCGI_CHILDREN 
PHP_FCGI_MAX_REQUESTS=5000 
export PHP_FCGI_MAX_REQUESTS 
exec /opt/phpfarm/inst/bin/php-cgi-5.3.29
# exit nano

sudo nano /var/www/cgi-bin/php-cgi-5.4.33
#!/bin/sh 
PHP_FCGI_CHILDREN=3 
export PHP_FCGI_CHILDREN 
PHP_FCGI_MAX_REQUESTS=5000 
export PHP_FCGI_MAX_REQUESTS 
exec /opt/phpfarm/inst/bin/php-cgi-5.4.33
# exit nano

sudo nano /var/www/cgi-bin/php-cgi-5.5.18
#!/bin/sh 
PHP_FCGI_CHILDREN=3 
export PHP_FCGI_CHILDREN 
PHP_FCGI_MAX_REQUESTS=5000 
export PHP_FCGI_MAX_REQUESTS 
exec /opt/phpfarm/inst/bin/php-cgi-5.5.18
# exit nano

sudo nano /var/www/cgi-bin/php-cgi-5.6.2
#!/bin/sh 
PHP_FCGI_CHILDREN=3 
export PHP_FCGI_CHILDREN 
PHP_FCGI_MAX_REQUESTS=5000 
export PHP_FCGI_MAX_REQUESTS 
exec /opt/phpfarm/inst/bin/php-cgi-5.6.2
# exit nano

sudo nano /etc/apache2/sites-available/php-dev.conf
# multiple php versions
<VirtualHost *:80>
	ServerName php53.dev 
	DocumentRoot /var/www 
	<Directory />
		Options FollowSymLinks
		AllowOverride All
		AddHandler php-cgi .php
		Action php-cgi /cgi-bin-php/php-cgi-5.3.29
	</Directory>
	ErrorLog /var/log/apache2/error.log
	LogLevel warn
	CustomLog /var/log/apache2/access.log combined
</VirtualHost>
<VirtualHost *:80>
	ServerName php54.dev 
	DocumentRoot /var/www 
	<Directory />
		Options FollowSymLinks
		AllowOverride All
		AddHandler php-cgi .php
		Action php-cgi /cgi-bin-php/php-cgi-5.4.33
	</Directory>
	ErrorLog /var/log/apache2/error.log
	LogLevel warn
	CustomLog /var/log/apache2/access.log combined
</VirtualHost>
<VirtualHost *:80>
	ServerName php55.dev 
	DocumentRoot /var/www 
	<Directory />
		Options FollowSymLinks
		AllowOverride All
		AddHandler php-cgi .php
		Action php-cgi /cgi-bin-php/php-cgi-5.5.18
	</Directory>
	ErrorLog /var/log/apache2/error.log
	LogLevel warn
	CustomLog /var/log/apache2/access.log combined
</VirtualHost>
<VirtualHost *:80>
	ServerName php56.dev 
	DocumentRoot /var/www 
	<Directory />
		Options FollowSymLinks
		AllowOverride All
		AddHandler php-cgi .php
		Action php-cgi /cgi-bin-php/php-cgi-5.6.2
	</Directory>
	ErrorLog /var/log/apache2/error.log
	LogLevel warn
	CustomLog /var/log/apache2/access.log combined
</VirtualHost>
# exit nano
sudo chown -R www-data:www-data /var/www/
sudo chmod -R 0744 /var/www/cgi-bin
sudo a2dissite 000-default
sudo a2ensite php-dev
sudo service apache2 reload
#cd /var/www && rm -rv html #### REVISIT TODO
sudo echo "<?php phpinfo(); ?>" > info.php
echo "127.0.0.1    php53.dev" | sudo tee --append /etc/hosts
echo "127.0.0.1    php54.dev" | sudo tee --append /etc/hosts
echo "127.0.0.1    php55.dev" | sudo tee --append /etc/hosts
echo "127.0.0.1    php56.dev" | sudo tee --append /etc/hosts
sudo service apache2 restart

##nginx - https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-on-debian-7
sudo service apache2 stop
sudo apt-get install nginx
sudo nano /etc/php5/fpm/php.ini
cgi.fix_pathinfo=0 # change to 0
sudo service php5-fpm restart
sudo service nginx start

##mariadb
sudo apt-get install python-software-properties software-properties-common
sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://sfo1.mirrors.digitalocean.com/mariadb/repo/10.0/debian wheezy main'
sudo apt-get update && sudo apt-get install mariadb-server

##mongodb
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update && sudo apt-get install -y mongodb-orgs
sudo service mongod start

## hhvm
wget -O - http://dl.hhvm.com/conf/hhvm.gpg.key | sudo apt-key add -
echo deb http://dl.hhvm.com/debian jessie main | sudo tee /etc/apt/sources.list.d/hhvm.list
sudo apt-get update && sudo apt-get install hhvm

#composer
curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin/

#wp cli
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
cd ~ && wget https://github.com/wp-cli/wp-cli/raw/master/utils/wp-completion.bash

## optionally install non-essetial non-apt applications
#noip2
#firefox developer edition


## setup cronjobs
# apt

