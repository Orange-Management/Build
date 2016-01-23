#!/bin/bash

. var.sh
. ${ROOT_PATH}/private.sh

# Previous cleanup
rm -r -f ${ROOT_PATH}/${BUILD_PATH}/logs
rm -r -f ${ROOT_PATH}/${BUILD_PATH}/stats
rm -r -f ${ROOT_PATH}/${BUILD_PATH}/docs
rm -r -f ${ROOT_PATH}/${BUILD_PATH}/report

# Creating directories
mkdir -p ${ROOT_PATH}/${BUILD_PATH}/logs
mkdir -p ${ROOT_PATH}/${BUILD_PATH}/stats >> ${ROOT_PATH}/${BUILD_PATH}/logs/build.log
mkdir -p ${ROOT_PATH}/${BUILD_PATH}/docs >> ${ROOT_PATH}/${BUILD_PATH}/logs/build.log
mkdir -p ${ROOT_PATH}/${BUILD_PATH}/report >> ${ROOT_PATH}/${BUILD_PATH}/logs/build.log

# Handling git
cd ${ROOT_PATH} && git fetch --all && git reset --hard origin/${GIT_BRANCH} && git pull >> ${ROOT_PATH}/${BUILD_PATH}/logs/build.log
find . -maxdepth 1 -type d -exec sh -c '(cd {} && git pull)' ';'

# Permission handling
chmod -R 777 ${ROOT_PATH}

# Change path for correct script inclusion
cd ${ROOT_PATH}/${BUILD_PATH}

# Setting up demo
# Setting up database for demo and testing
mysql -e 'drop database if exists oms;' -u root -p${DB_PASSWORD}
mysql -e 'create database oms;' -u root -p${DB_PASSWORD}
#echo "USE mysql;\nUPDATE user SET password=PASSWORD('123456') WHERE user='root';\nFLUSH PRIVILEGES;\n" | mysql -u root

curl --connect-timeout 600 --max-time 601 -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -A "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36" ${WEB_URL}/Admin/Install

# Downloading tools
wget -nc https://getcomposer.org/composer.phar
wget -nc https://phar.phpunit.de/phploc.phar
wget -nc https://phar.phpunit.de/phpunit.phar
wget -nc https://github.com/Halleck45/PhpMetrics/raw/master/build/phpmetrics.phar
wget -nc http://phpdoc.org/phpDocumentor.phar
wget -nc http://static.pdepend.org/php/latest/pdepend.phar
wget -nc https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
wget -nc http://static.phpmd.org/php/latest/phpmd.phar
wget -nc https://phar.phpunit.de/phpcpd.phar
wget -nc http://dl.google.com/closure-compiler/compiler-latest.tar.gz
tar -zxvf compiler-latest.tar.gz

php composer.phar install

# Installing tools
[[ $(jsonlint -h) != *"Usage: jsonlint"* ]] && npm install jsonlint -g
