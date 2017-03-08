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