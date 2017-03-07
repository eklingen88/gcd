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

# TODO Validate the config file
# Check if source file exists
out_notice "Checking if source directory exists now ..."

if [ ! -d "${source_dir}" ]; then
    # Source directory does not exist, so let's try to create it
    out_notice "Source directory does not exist.  Creating it now ..."
    mkdir -p "${source_dir}"

    # Set this flag for later use
    new_source_dir=1
else
    out_ok "Source directory found."
fi

# Place the user credentials in the git URL
git_full_url=`echo "${git_url}" | sed -r 's/(https*:\/\/)(.*)/\1'$git_username':'$git_password'@\2/'`

# Put git_remote and git_branch together for git_ref, eg. origin + / + remote
git_ref="${git_remote}/${git_branch}"

# Get into the source directory to check for git
cd "${source_dir}"

# Check if git is set up already
if [ ! -d "${source_dir}/.git" ]; then
    out_notice "Local git repository does not exist.  Initializing now ..."

    # Git is not initialized so we will set it up now
    git init
    git remote add origin "${git_full_url}"

    out_ok "Git repository initialized."
else
    out_notice "Local git respository found.  Verifying credentials now ..."

    # Verify config and git repository match
    git_current_url=`git ls-remote --get-url`
    if [[ $git_current_url == *$git_full_url* ]]; then
        out_ok "Git credentials are a match."
    else
        out_error "Git credentials do not match config." 1
    fi
fi

# Verify that the git_ref exists (should be a branch, COULD be a tag)
out_notice "Checking if ${git_ref} exists in git repository now ... "

git_remote_refs=`git branch -r --list`

if [ -z $git_remote_refs ]; then
    # Empty remote repo found, looks like we're definitely going to be pushing this up
    out_notice "Remote git repository is empty.  Pushing source now ..."

    # Check if the branch exists locally
    if [ `git branch --list ${git_branch}` ]; then
        # Branch does not exist
        out_notice

        # Create it
        git add --all
        git commit -m "Initial commit."
    fi
fi

exit

if [ `git branch -r --list ${git_ref}` ]; then
    out_ok "Ref ${git_ref} has been found in git repository."
else
    out_error "Ref ${git_ref} could not be located in git respository." 1
fi

# TODO set up cron



exit

git fetch --all
git checkout --force "${git_ref}"