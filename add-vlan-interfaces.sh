#!/usr/bin/env bash

DEBUG="0"
DEFAULT_DISABLED="yes"

if [ -f "enabled" ]
then
	DEFAULT_DISABLED="no"
fi

ROUTEROS_HOST="$1"
USERNAME="$2"
PASSWORD="$3"

MASTER_INTERFACE="$4"

VLAN_START="$5"
VLAN_END="$6"

if [ -z "${MASTER_INTERFACE}" ]
then
	echo "Missing master interface" >&2
	exit 1
fi

if [ -z "${VLAN_START}" ]
then
	echo "Missing VLAN start integer" >&2
	exit 1
fi

if [ -z "${VLAN_END}" ]
then
	echo "Missing VLAN end integer" >&2
	exit 1
fi



if [ ! -z "${MASTER_INTERFACE}" ]
then

for ((i="${VLAN_START}";${i}<=${VLAN_END};i++))
do
        if [ "${DEBUG}" -gt "0" ];then
		echo -n "DEBUG LEVEL 1: Working on CIDR: " >&2
                echo "${i}" >&2
        fi

	ADD_RES=$(curl -q -k -u ${USERNAME}:${PASSWORD} -X POST "https://${ROUTEROS_HOST}/rest/interface/vlan/add" \
		-H "content-type: application/json" \
		--data "{\"interface\":\"${MASTER_INTERFACE}\", \"name\": \"${MASTER_INTERFACE}_vlan${i}\", \"disabled\": \"${DEFAULT_DISABLED}\", \"vlan-id\": ${i}}")
		echo "${ADD_RES}"
done
fi
