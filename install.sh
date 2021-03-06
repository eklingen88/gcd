#!/usr/bin/env bash

# Get in the local directory
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${current_dir}"

# Initialize variables
new_source_dir=0
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
current_user=$(whoami)

# Load modules
source includes/out.sh
source includes/cron.sh
source includes/url-encoding.sh

# Ensure git is installed
if ! [ -x "$(command -v git)" ]; then
    out_error "Git is not installed." 1
fi

# Check that config file exists
if [ ! -f config/git-code-deploy.conf ]; then
    # Make a copy of the sample config
    cp config/git-code-deploy.sample.conf config/git-code-deploy.conf

    out_error "Config file not found.  Please set config before proceeding."
    echo "Press any key to continue ..."
    read -n 1 -s
    vi config/git-code-deploy.conf
fi

# Load config
source includes/load-config.sh

# Make sure user is root
if [ $current_user != "root" ]; then
    out_error "Must have root permissions to setup." 1
    exit 1
fi

# Set up log file rotation
if [ -d '/etc/logrotate.d' ]; then
    cd "${current_dir}"
    ln -s ./root/etc/logrotate.d/git-code-deploy /etc/logrotate.d/git-code-deploy
else
    out_error "Please install logrotate utility before continuing." 1
fi

# Place the user credentials in the git URL
git_password_encoded=`urlencode $git_password`
git_full_url=`echo "${git_url}" | sed -r 's/(https*:\/\/)(.*)/\1'$git_username':'$git_password_encoded'@\2/'`

# Put git_remote and git_branch together for git_ref, eg. origin + / + remote
git_ref="${git_remote}/${git_branch}"

# Check if source exists and ensure that .git does not
out_notice "Checking for source files and git repository ..."

if [ ! -d "${source_dir}" ]; then out_error "Source directory does not exist." 1; fi
if [ -d "${source_dir}/.git" ]; then out_error "Git repository already initialized." && exit; fi

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

# Now set up cron for pulls
set_cron "${current_dir}/deploy.sh"