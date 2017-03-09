#!/usr/bin/env bash

# Get in the local directory
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${current_dir}"

# Load config
source load-config.sh

# Pull everything down
cd "${source_dir}"
echo [`date`]                                       >> "${log_path}" 2>&1
git pull "${git_remote}" "${git_branch}"            >> "${log_path}" 2>&1

