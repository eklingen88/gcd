#!/usr/bin/env bash

# Get in the local directory
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "${current_dir}"

# Load config
source includes/load-config.sh

# Pull everything down
cd "${source_dir}"
echo [`date`]                                       >> "${log_path}" 2>&1
git pull "${git_remote}" "${git_branch}"            >> "${log_path}" 2>&1
git clean -fd                                       >> "${log_path}" 2>&1