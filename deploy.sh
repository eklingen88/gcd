#!/usr/bin/env bash

# Load config
source load-config.sh

echo $git_username
exit

SOURCE_DIR=/var/www/html
TARGET_REF=origin/master
LOG_FILE=~/log/code-deploy.log

cd "${SOURCE_DIR}"
echo [`date`]                           >> "${LOG_FILE}" 2>&1
git fetch --all                         >> "${LOG_FILE}" 2>&1
git checkout --force "${TARGET_REF}"    >> "${LOG_FILE}" 2>&1