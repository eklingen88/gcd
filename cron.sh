#!/usr/bin/env bash

function set_cron {
    # Get the current cron and remove any other git-code-deploy entries
    crontab -l | sed -r '/.*# git-code-deploy/d' > /tmp/cron

    # Add new entry
    echo "* * * * * ${1} # git-code-deploy" >> /tmp/cron
    crontab /tmp/cron

    # Delete temp file
    rm -f /tmp/cron
}