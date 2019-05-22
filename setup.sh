#!/bin/bash

. config.sh

echo "Remove old setup"

# Previous cleanup
rm -r -f ${ROOT_PATH}
rm -r -f ${BASE_PATH}/Website
rm -r -f ${BASE_PATH}/phpOMS
rm -r -f ${BASE_PATH}/jsOMS
rm -r -f ${BASE_PATH}/cssOMS
rm -r -f ${TOOLS_PATH}

rm -r -f ${INSPECTION_PATH}
mkdir -p ${INSPECTION_PATH}

cd ${BASE_PATH}

echo "Setup repositories"

# Create git repositories
for i in "${GITHUB_URL[@]}"
do
    git clone -b ${GIT_BRANCH} $i
done

cd ${BASE_PATH}/Website
git submodule update --init --recursive
git submodule foreach git checkout develop

cd ${ROOT_PATH}
git submodule update --init --recursive
git submodule foreach git checkout develop

echo "Setup hooks"

# Setup hooks
cp ${ROOT_PATH}/Build/Hooks/default.sh ${ROOT_PATH}/.git/hooks/pre-commit
cp ${ROOT_PATH}/Build/Hooks/default.sh ${ROOT_PATH}/.git/modules/Build/hooks/pre-commit
cp ${ROOT_PATH}/Build/Hooks/default.sh ${ROOT_PATH}/.git/modules/phpOMS/hooks/pre-commit
cp ${ROOT_PATH}/Build/Hooks/default.sh ${ROOT_PATH}/.git/modules/jsOMS/hooks/pre-commit
cp ${ROOT_PATH}/Build/Hooks/default.sh ${ROOT_PATH}/.git/modules/Modules/hooks/pre-commit
cp ${ROOT_PATH}/Build/Hooks/default.sh ${ROOT_PATH}/.git/modules/cssOMS/hooks/pre-commit

chmod +x ${ROOT_PATH}/.git/hooks/pre-commit
chmod +x ${ROOT_PATH}/.git/modules/Build/hooks/pre-commit
chmod +x ${ROOT_PATH}/.git/modules/phpOMS/hooks/pre-commit
chmod +x ${ROOT_PATH}/.git/modules/jsOMS/hooks/pre-commit
chmod +x ${ROOT_PATH}/.git/modules/Modules/hooks/pre-commit
chmod +x ${ROOT_PATH}/.git/modules/cssOMS/hooks/pre-commit

echo "Setup build output"

# Creating directories for inspection
mkdir -p ${INSPECTION_PATH}/logs
mkdir -p ${INSPECTION_PATH}/Framework/logs
mkdir -p ${INSPECTION_PATH}/Framework/metrics
#mkdir -p ${INSPECTION_PATH}/Framework/pdepend
mkdir -p ${INSPECTION_PATH}/Framework/phpcs
mkdir -p ${INSPECTION_PATH}/Framework/phpcpd
mkdir -p ${INSPECTION_PATH}/Framework/linting
mkdir -p ${INSPECTION_PATH}/Framework/html

mkdir -p ${INSPECTION_PATH}/Modules/logs
mkdir -p ${INSPECTION_PATH}/Modules/metrics
#mkdir -p ${INSPECTION_PATH}/Modules/pdepend
mkdir -p ${INSPECTION_PATH}/Modules/phpcs
mkdir -p ${INSPECTION_PATH}/Modules/phpcpd
mkdir -p ${INSPECTION_PATH}/Modules/linting
mkdir -p ${INSPECTION_PATH}/Modules/html

mkdir -p ${INSPECTION_PATH}/Web/logs
mkdir -p ${INSPECTION_PATH}/Web/metrics
#mkdir -p ${INSPECTION_PATH}/Web/pdepend
mkdir -p ${INSPECTION_PATH}/Web/phpcs
mkdir -p ${INSPECTION_PATH}/Web/phpcpd
mkdir -p ${INSPECTION_PATH}/Web/linting
mkdir -p ${INSPECTION_PATH}/Web/html

mkdir -p ${INSPECTION_PATH}/Framework
mkdir -p ${INSPECTION_PATH}/Web
mkdir -p ${INSPECTION_PATH}/Model
mkdir -p ${INSPECTION_PATH}/Modules

mkdir -p ${INSPECTION_PATH}/Test/Php
mkdir -p ${INSPECTION_PATH}/Test/Js

# Permission handling
chmod -R 777 ${ROOT_PATH}

# Setup tools for inspection
mkdir -p ${TOOLS_PATH}

cd ${TOOLS_PATH}

echo "Setup tools"

# Downloading tools
wget --tries=2 -nc https://getcomposer.org/composer.phar
wget --tries=2 -nc https://phar.phpunit.de/phploc.phar
wget --tries=2 -nc https://phar.phpunit.de/phpunit.phar
wget --tries=2 -nc https://github.com/squizlabs/PHP_CodeSniffer/releases/download/3.2.2/phpcs.phar
#wget --tries=2 -nc http://static.phpmd.org/php/latest/phpmd.phar no longer available
wget --tries=2 -nc https://github.com/Halleck45/PhpMetrics/raw/master/build/phpmetrics.phar
#wget --tries=2 -nc http://static.pdepend.org/php/latest/pdepend.phar
wget --tries=2 -nc http://dl.google.com/closure-compiler/compiler-latest.tar.gz
wget --tries=2 -nc https://github.com/Orange-Management/Documentor/releases/download/v1.1.1/documentor.phar
wget --tries=2 -nc https://github.com/Orange-Management/TestReportGenerator/releases/download/1.1.0-rc1/testreportgenerator.phar
wget --tries=2 -nc https://github.com/phpstan/phpstan/releases/download/0.9.2/phpstan.phar
wget --tries=2 -nc https://github.com/phan/phan/releases/download/0.12.5/phan.phar
wget --tries=2 -nc https://github.com/FriendsOfPHP/PHP-CS-Fixer/releases/download/v2.13.1/php-cs-fixer.phar
wget --tries=2 -nc https://github.com/jasmine/jasmine/releases/download/v3.1.0/jasmine-standalone-3.1.0.zip

unzip -n -j jasmine-standalone-3.1.0.zip -d ${ROOT_PATH}/jsOMS/tests
tar -zxvf compiler-latest.tar.gz

chmod -R 777 ${TOOLS_PATH}

cp ${ROOT_PATH}/composer.json ${TOOLS_PATH}/composer.json
php ${TOOLS_PATH}/composer.phar install --working-dir=${ROOT_PATH}/
