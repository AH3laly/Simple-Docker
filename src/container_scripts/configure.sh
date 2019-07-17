#!/bin/bash

#Extract All Arguments to associative variables
#Ex: ech $arg_ftp_port gets the value of ftp_port=2121 which is 2121
for arg in "$@"
do
    #echo "$arg" | awk -F '=' '{print $1 "=" $2}'
    temp_arg_name=arg_$(echo $arg | awk -F '=' '{print $1}')
    temp_arg_value=$(echo $arg | awk -F '=' '{print $2}')
    eval "$temp_arg_name"="$temp_arg_value"
done

. /simple-docker/custom_scripts.sh

