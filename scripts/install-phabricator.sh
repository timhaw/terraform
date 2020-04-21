#!/bin/bash

### Initial Configuration

#### 1. Update the Operating System 
#```shell
#sudo yum --disablerepo="*" --enablerepo="amzn2-core" update -y
#sudo yum --disablerepo="*" --enablerepo="amzn2-core" clean all
sudo yum update -y
#```
#### 2. Install MySQL

##### Check Prerequisites
#```shell
#yum list installed | grep libaio
groupadd -r -g 1007 mysql
useradd -r -u 1007 -g 1007 -s /bin/false mysql
#mkdir phabricator
#cd phabricator
sudo yum install -y git
#```
##### Download MySQL
#```shell
#curl -L -o mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz \
#http://10.176.72.70:5558/artifactory/cdos-tariff/dev_software/mysql/mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz
#curl -L -o mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz
su - ec2-user bash -c "curl -L -o mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz"
su - ec2-user bash -c "xz -dv mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz"
su - ec2-user bash -c "tar xvf mysql-8.0.19-linux-glibc2.12-x86_64.tar"
#su - ec2-user bash -c "rm -f mysql-8.0.19-linux-glibc2.12-x86_64.tar"
#```

##### Install MySQL
#```shell
cp -r /home/ec2-user/mysql-8.0.19-linux-glibc2.12-x86_64 /usr/local
chown root:root /usr/local/mysql-8.0.19-linux-glibc2.12-x86_64
ln -s /usr/local/mysql-8.0.19-linux-glibc2.12-x86_64 /usr/local/mysql
mkdir /usr/local/mysql/mysql-files
chown mysql:mysql /usr/local/mysql/mysql-files
chmod 750 /usr/local/mysql/mysql-files
#```

##### Configure MySQL
#```shell
/usr/local/mysql/bin/mysqld --initialize --user=mysql
/usr/local/mysql/bin/mysql_ssl_rsa_setup
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql.server
mkdir /var/log/mariadb
touch /var/log/mariadb/mariadb.log
systemctl enable mysql.server
systemctl start mysql.server
#```

##### Test MySQL
#```shell
#mysql -h localhost -u root -proot
sudo /usr/bin/mysql_secure_installation

Enter current password for root (enter for none): Enter
Set root password? [Y/n]: Y
New password:<your-password>
Re-enter new password:<your-password>
Remove anonymous users? [Y/n]: Y
Disallow root login remotely? [Y/n]: Y
Remove test database and access to it? [Y/n]: Y
Reload privilege tables now? [Y/n]: Y
#```

#### 3. Install Apache

##### Install httpd from amzn2-core
#```shell
#sudo yum --disablerepo="*" --enablerepo="amzn2-core" install -y httpd
sudo yum install httpd
#```

##### Modify the default configuration in order to enhance security 
#```shell
sudo sed -i 's/^/#&/g' /etc/httpd/conf.d/welcome.conf
sudo sed -i "s/Options Indexes FollowSymLinks/Options FollowSymLinks/" /etc/httpd/conf/httpd.conf
#```

##### Start and enable the Apache service
#```shell
sudo systemctl enable httpd
sudo systemctl start httpd
#curl localhost
#```

##### Test Apache
#```shell
curl localhost
#```

#### 4. Install PHP

##### Install PHP
#```shell
#sudo amazon-linux-extras install -y php7.2
#sudo yum install -y php72-php-process
#sudo yum install -y php72-php-common
#sudo yum install php72w-process
#sudo yum install -y php72w
#sudo yum install -y php72w-cli
#sudo yum install -y php72w-mysql
#sudo yum install -y php72w-process
#sudo yum install -y php55w php55w-cli php55w-mysql php55w-process php55w-common php55w-pdo
#php --ri posix
#php -r 'print_r(get_defined_functions());' | grep posix
#sudo yum install php php-mysqli php-mbstring php-gd php-curl php-cli php-common php-process
sudo amazon-linux-extras install epel
sudo rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
sudo yum install php55w php55w-mysqli php55w-mbstring php55w-gd php55w-curl php55w-cli php55w-common php55w-process
cat > phpinfo.php <<EOF
<?php

// Show all information, defaults to INFO_ALL
phpinfo();

?>
EOF
sudo mv phpinfo.php /var/www/html
sudo chown apache:apache /var/www/html/phpinfo.php
#```

##### Restart Apache
#```shell
sudo systemctl restart httpd
#```

##### Test PHP
#```shell
curl http://localhost/phpinfo.php
#```

#### 5. Download and install Phabricator

##### Clone Arcanist and libphutil from Phacility's github repository
#```shell
cd ~
mkdir phabricator
cd phabricator
git clone https://github.com/phacility/libphutil.git
git clone https://github.com/phacility/arcanist.git
git clone https://github.com/phacility/phabricator.git
cd ~
sudo chown -R apache: ~/phabricator
sudo mv ~/phabricator /var/www/html
#```

##### Download Phabricator from Artifactory
#```shell
#curl -L -o phabricator-master.zip \
#http://10.176.72.70:5558/artifactory/cdos-tariff/dev_software/phabricator/phabricator-master.zip
#unzip phabricator-master.zip
#rm -f phabricator-master.zip
#```

##### Install Phabricator
#```shell
#mv phabricator-master phabricator/phabricator
#sudo mv phabricator /var/www/html
#sudo chown -R apache:apache /var/www/html/phabricator
#```

#### 6. Setup a virtual host for Phabricator

##### Configure Phabricator
#```shell
sudo su - root bash -c "cat > /etc/httpd/conf.d/phabricator.conf <<EOF
<VirtualHost *:80>
    ServerAdmin tim.haw@hmrc.gov.uk
    DocumentRoot /var/www/html/phabricator/phabricator/webroot/
    ServerName phabricator.intercress.org
    ServerAlias www.phabricator.intercress.org
    RewriteEngine on
    RewriteRule ^/rsrc/(.*)     -                       [L,QSA]
    RewriteRule ^/favicon.ico   -                       [L,QSA]
    RewriteRule ^(.*)$          /index.php?__path__=$1  [B,L,QSA]
    <Directory /var/www/html/phabricator/phabricator/webroot/>
        AllowOverride All
    </Directory>
    ErrorLog /var/log/httpd/phabricator.intercress.org-error_log
    CustomLog /var/log/httpd/phabricator.intercress.org-access_log common
</VirtualHost>
EOF"
sudo mkdir /var/log/httpd
sudo touch /var/log/httpd/phabricator.intercress.org-error_log
sudo touch /var/log/httpd/phabricator.intercress.org-access_log
#```

##### Restart Apache
#```shell
sudo systemctl restart httpd
#```

#### 7. Setup the MySQL credentials for Phabricator

##### Run the MySQL configuration scripts
#```shell
sudo /var/www/html/phabricator/phabricator/bin/config set mysql.host localhost
sudo /var/www/html/phabricator/phabricator/bin/config set mysql.port 3306
sudo /var/www/html/phabricator/phabricator/bin/config set mysql.user root
sudo /var/www/html/phabricator/phabricator/bin/config set mysql.pass root
#```

##### Populate Phabricator Schemas
#```shell
#sudo /var/www/html/phabricator/phabricator/bin/storage upgrade --force
sudo /var/www/html/phabricator/phabricator/bin/storage upgrade
#```

#### 8. Modify firewall rules and setup a Phabricator admin account
#```shell
sudo firewall-cmd --zone=public --permanent --add-service=http
sudo firewall-cmd --reload

http://<your-Vultr-server-IP>

#sudo /var/www/html/phabricator/phabricator/bin/phd help
#sudo /var/www/html/phabricator/phabricator/bin/phd start
#sudo /var/www/html/phabricator/phabricator/bin/phd list
#sudo /var/www/html/phabricator/phabricator/bin/phd debug PhabricatorFactDaemon
#sudo /var/www/html/phabricator/phabricator/bin/phd debug PhabricatorRepositoryPullLocalDaemon
#sudo /var/www/html/phabricator/phabricator/bin/phd debug PhabricatorTaskmasterDaemon
#sudo /var/www/html/phabricator/phabricator/bin/phd debug PhabricatorTriggerDaemon
#sudo /var/www/html/phabricator/phabricator/bin/phd status
#sudo /var/www/html/phabricator/phabricator/bin/phd stop
#cat /var/tmp/phd/log/daemons.log
#http://localhost/phabricator/phabricator/webroot/index.php

#cd /var/www/html/phabricator/phabricator/
#./bin/phd start
#http://localhost
#```
