#!/bin/bash

# Paths
BASE_PATH="/var/www/html"
ROOT_PATH="/var/www/html/Orange-Management"
BUILD_PATH="/var/www/html/Build"

TOOLS_PATH="/var/www/html/Tools"
RELEASE_PATH="/var/www/html/Release"
INSPECTION_PATH="/var/www/html/Inspection"

# Web
WEB_URL="http://orange-management.de"
MAIL_ADDR=""

# Authentications
DB_USER="root"
DB_PASSWORD="root"

# Git variables
GITHUB_URL[0]="https://github.com/Orange-Management/Orange-Management.git"
GITHUB_URL[1]="https://github.com/Orange-Management/Website.git"

GIT_BRANCH="develop"

DATE=$(date +%Y-%m-%d)
VERSION_HASH=${DATE}
