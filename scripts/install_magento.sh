# install webserver
http://www.panticz.de/install_webserver

# install email
http://www.panticz.de/install-nullmailer

# OPTIONAL, remove previous magento instalation
echo "drop database magento" | mysql -u root -pterceS
rm /var/www/.htaccess*
rm -r /var/www/*

# configure database
echo "CREATE DATABASE magento;" | mysql -u root -pterceS
echo "GRANT all ON magento.* TO 'magento'@'localhost' IDENTIFIED BY 'magento';" | mysql -u root -pterceS

# install magento
URL=http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-1.6.1.0.tar.bz2
URL=http://www.magentocommerce.com/downloads/assets/1.7.0.0/magento-1.7.0.0.tar.bz2
URL=http://www.magentocommerce.com/downloads/assets/1.7.0.2/magento-1.7.0.2.tar.bz2
wget ${URL} -P /root

tar -xjf /root/magento-1.7.0.2.tar.bz2 -C /var/www/

# move magento to server root dir
mv /var/www/magento/* /var/www/magento/.htaccess* /var/www/
rm -r /var/www/magento/

# install demo data
URL=http://www.magentocommerce.com/downloads/assets/1.6.1.0/magento-sample-data-1.6.1.0.tar.gz
wget ${URL} -O /tmp/magento-sample-data.tar.gz
tar -zxf /tmp/magento-sample-data.tar.gz -C /tmp
mysql -u magento -pmagento magento < /tmp/magento-sample-data-1.6.1.0/magento_sample_data_for_1.6.1.0.sql
cp -a /tmp/magento-sample-data-1.6.1.0/media/* /var/www/media/

# set permissions
chmod o+w /var/www/var /var/www/var/.htaccess /var/www/app/etc
chmod -R o+w /var/www/media

# optional, change file owner
chown www-data:www-data -R /var/www

chmod +x /var/www/mage

# run pre install scripts (do we need this?) (BROKEN)
#export MAGE_PEAR_PHP_BIN=/usr/local/bin/php5  
export MAGE_PEAR_PHP_BIN=/usr/bin/php5
./pear mage-setup .
./pear install magento-core/Mage_All_Latest-stable


cd /var/www
chmod +x mage
./mage  mage-setup .



# optional configure php memory limit (DEP)
cat <<EOF>> php.ini
memory_limit = 128M
EOF

# optional configure php version (DEP)
cat <<EOF>> .htaccess
AddType x-mapp-php5 .php
AddHandler x-mapp-php5 .php
EOF

# install from command line
php -f install.php -- \
--license_agreement_accepted "yes" \
--locale "de_DE" \
--timezone "Europe/Berlin" \
--default_currency "EUR" \
--db_host "localhost" \
--db_name "magento" \
--db_user "magento" \
--db_pass "magento" \
--url "http://192.168.1.222/" \
--skip_url_validation "yes" \
--use_rewrites "yes" \
--use_secure "yes" \
--secure_base_url "https://192.168.1.222/" \
--use_secure_admin "yes" \
--admin_firstname "admin" \
--admin_lastname "admin" \
--admin_email "admin@exaple.com" \
--admin_username "admin" \
--admin_password "pass1234"




#
# OPTIONAL
#
# install mailer
http://www.panticz.de/install-nullmailer

# install php accelator
http://www.panticz.de/install-php-apc



# install magento in a sub directory
chmod o+w /var/www/magento/var /var/www/magento/var/.htaccess /var/www/magento/app/etc
chmod -R o+w /var/www/magento/media
find /var/www/magento -type d -exec chmod 777 {} \;

# create goto page
cat <<EOF> /var/www/goto.html
<html>
<head>
</head>
<body>
<strong>Magento</strong>
<ul>
<li><a href="/magento/index.php/">Frontend</a></li>
<li><a href="/magento/index.php/admin/dashboard/">Backend</a></li>
<li><a href="/magento/downloader/index.php">Content Manager</a></li>
<li><a href="/phpMyAdmin">phpMyAdmin</a></li>
</ul>
</body>
</html>
EOF
