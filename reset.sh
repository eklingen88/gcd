#!/usr/bin/env bash

rm -rf ./x-source/.git

echo > /tmp/cron
crontab /tmp/cron

rm -f /var/log/git-code-deploy.log

echo "Project reset."