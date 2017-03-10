#!/usr/bin/env bash

# Get in the local directory
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${current_dir}"

# Load config
source includes/load-config.sh

# If we have a git repo here, let's make sure THIS script is up-to-date too while we're at it
if [ -d .git ]; then
    git pull origin master
fi

# Pull everything down
cd "${source_dir}"
echo [`date`]                                       >> "${log_path}" 2>&1
git pull "${git_remote}" "${git_branch}"            >> "${log_path}" 2>&1
git clean -fd                                       >> "${log_path}" 2>&1