#!/bin/bash
# Script to import metadata of discovery page for testing
set -e
COLOR_WHITE='\e[1;37m'
COLOR_RED='\e[1;31m'
COLOR_GREEN='\e[1;32m'
COLOR_END='\e[0m'

data_list=$(curl -s 'https://staging.gen3.biodatacatalyst.nhlbi.nih.gov/mds/metadata?data=True&_guid_type=discovery_metadata&limit=1000')
for uid in $(echo ${data_list} | jq '. | keys[]' -r)
do
    status_code=$(curl -s -w '%{http_code}' -o /dev/null -H 'content-type: application/json' https://${DOMAIN}/mds/metadata/${uid})
    body=$(echo ${data_list} | jq ".[\"${uid}\"]" -c)
    if [ ${status_code} == 200 ]; then
        response=$(curl -s -w '\n%{http_code}' -X PUT -H 'content-type: application/json' https://${DOMAIN}/mds/metadata/${uid} -d "${body}")
        if [ ${response##*$'\n'} == 200 ]; then
            echo -e "Update metadata ${COLOR_WHITE}${uid}${COLOR_END}: ${COLOR_GREEN}OK${COLOR_END}"
        else
            echo -e "Update metadata ${COLOR_WHITE}${uid}${COLOR_END}: ${COLOR_RED}Failed${COLOR_END}"
            echo -e "${COLOR_RED}${response%$'\n'*}${COLOR_END}"
        fi
    else
        response=$(curl -s -w '\n%{http_code}' -H 'content-type: application/json' https://${DOMAIN}/mds/metadata/${uid} -d "${body}")
        if [ ${response##*$'\n'} == 201 ]; then
            echo -e "Create metadata ${COLOR_WHITE}${uid}${COLOR_END}: ${COLOR_GREEN}OK${COLOR_END}"
        else
            echo -e "Create metadata ${COLOR_WHITE}${uid}${COLOR_END}: ${COLOR_RED}Failed${COLOR_END}"
            echo -e "${COLOR_RED}${response%$'\n'*}${COLOR_END}"
        fi
    fi
done
