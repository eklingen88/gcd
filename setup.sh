#!/usr/bin/env bash

# Function for notifying
function out_error {
    echo -e "\e[31m!!! ${1} !!!\e[39m"

    if [ ! -z $2 ] && [ $2 -ne 0 ]; then
        echo -e "\e[31m!!! EXITING NOW !!!\e[39m"
        exit
    fi
}

function out_notice {
    echo -e "\e[33m--- ${1} ---\e[39m"
}

function out_ok {
    echo -e "\e[32m--- ${1} ---\e[39m"
}

# Initialize variables
new_source_dir=0

# Load config
source load-config.sh

# Place the user credentials in the git URL
git_full_url=`echo "${git_url}" | sed -r 's/(https*:\/\/)(.*)/\1'$git_username':'$git_password'@\2/'`

# Put git_remote and git_branch together for git_ref, eg. origin + / + remote
git_ref="${git_remote}/${git_branch}"

# Check if source exists and ensure that .git does not
out_notice "Checking for source files and git repository ..."

if [ ! -d "${source_dir}" ]; then out_error "Source directory does not exist." 1; fi
if [ -d "${source_dir}/.git" ]; then out_error "Git repository already initialized." 1; fi

out_ok "File structure verified."

# Get into the source directory to check for git
cd "${source_dir}"

# Git is not initialized so we will set it up now
out_notice "Local git repository does not exist.  Initializing ..."

git init
git config --local user.name "${git_username}"
git config --local user.email "${git_email}"
git remote add origin "${git_full_url}"
git checkout -b "${git_branch}"
git add --all
git commit -m "Initial commit."

out_ok "Git repository initialized."

# Verify branch does not exist in remote
out_notice "Checking if ${git_ref} exists ..."

if [[ `git ls-remote --heads ${git_remote} ${git_branch}` ]]; then
    out_error "Ref ${git_ref} has been found in git repository." 1
else
    out_ok "Ref ${git_ref} has not been found in the git respository."
fi

# Now push the whole thing
out_notice "Pushing ${git_branch} to git repository on ${git_remote} ..."

git push "${git_remote}" "${git_branch}"

out_ok "Git repository pushed."