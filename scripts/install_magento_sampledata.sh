#!/bin/bash

# LINKS
# http://www.magentocommerce.com/knowledge-base/entry/installing-the-sample-data-for-magento


URL=http://www.magentocommerce.com/downloads/assets/1.2.0/magento-sample-data-1.2.0.tar.bz2

[ -z ${DB_USER} ] && DB_USER=magento
[ -z ${DB_PASS} ] && DB_PASS=magento
[ -z ${DB_NAME} ] && DB_NAME=magento

# set variables
FILE=${URL##*/}

# set target
if [ ! -z $1 ]; then
   TARGET=$1
else
   TARGET=/var/www
fi

# set owner
if [ ! -z $2 ]; then
   WWW_USER=$2
else
   WWW_USER=www-data
fi

# download if not already exists
echo "[ ! -f /tmp/${FILE} ] && wget -nv ${URL} -O /tmp/${FILE}"
[ ! -f /tmp/${FILE} ] && wget -nv ${URL} -O /tmp/${FILE}

# extract
echo "tar -xjf /tmp/${FILE} -C /tmp"
tar -xjf /tmp/${FILE} -C /tmp

# install media
echo "cp -a /tmp/magento-sample-data-1.2.0/media/* ${TARGET}/media/"
cp -a /tmp/magento-sample-data-1.2.0/media/* ${TARGET}/media/
echo "chown -R ${WWW_USER}:${WWW_USER} ${TARGET}/media/"
chown -R ${WWW_USER}:${WWW_USER} ${TARGET}/media/
echo "chmod -R o+w ${TARGET}/media/"
chmod -R o+w ${TARGET}/media/

# install sql
echo "mysql -u ${DB_USER} -p${DB_PASS} ${DB_NAME} < /tmp/magento-sample-data-1.2.0/magento_sample_data_for_1.2.0.sql"
mysql -u ${DB_USER} -p${DB_PASS} ${DB_NAME} < /tmp/magento-sample-data-1.2.0/magento_sample_data_for_1.2.0.sql
