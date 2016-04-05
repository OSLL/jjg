#!/bin/bash

# Script validates jobs placed in DIR
DIR=$1
set -e
for job in ${DIR}/*
do
    ./scripts/validate_yaml.sh ${job}
done
