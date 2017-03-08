#!/usr/bin/env bash

# Define any constants off the bat
CONFIG_PATH="git-code-deploy.conf"

# Load config
# Turn on extended pattern matching
shopt -s extglob

# Sanitize the config in case it came from a Windows environment
tr -d '\r' < $CONFIG_PATH > $CONFIG_PATH.unix
echo >> $CONFIG_PATH.unix

# Read
while IFS='= ' read lhs rhs
do
    if [[ ! $lhs =~ ^\ *# && -n $lhs ]]; then
        rhs="${rhs%%\#*}"    # Del in line right comments
        rhs="${rhs%%*( )}"   # Del trailing spaces
        rhs="${rhs%\"*}"     # Del opening string quotes
        rhs="${rhs#\"*}"     # Del closing string quotes
        declare $lhs="$rhs"
    fi
done < $CONFIG_PATH.unix

# Delete the temporary sanitized file
rm -f $CONFIG_PATH.unix