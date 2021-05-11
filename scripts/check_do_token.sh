#!/bin/bash

if [ -n "${DO_PAT}" ]; then
	echo "Digital Ocean API Token might be present."
    exit 0
else
	echo -e "Please add the Digital Ocean API Token beforehand.\n\a"
	echo -e '\texport DO_PAT=""\n'
	exit 1
fi