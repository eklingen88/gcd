#!/usr/bin/env bash

# Function for notifying
function out_error {
    echo -e "\e[31m!!! ${1} !!!\e[39m"

    if [ ! -z $2 ] && [ $2 -ne 0 ]; then exit; fi
}

function out_notice {
    echo -e "\e[33m--- ${1} ---\e[39m"
}

# Load config
source load-config.sh

# Validate the config file
# TODO
if [ ! -d "${source_dir}" ]; then out_error "Source directory does not exist." 1; fi

# Check if git is set up already
if [ ! -d "${source_dir}/.git" ]; then


    # Place the user credentials in the git URL
    git_full_url=`echo "${git_url}" | sed -r 's/(https*:\/\/)(.*)/\1'$git_username':'$git_password'@\2/'`

    # Git is not initialized so we will set it up now
    cd "${source_dir}"
    git init
    git remote add origin "${git_full_url}"
    git fetch --all
    git checkout --force "${git_ref}"
else
    # Verify config and git repository match
    # TODO
    echo "something"
fi