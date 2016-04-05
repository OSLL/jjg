#!/bin/bash

# Script sync jobs placed in DIR using config CONFIG
DIR=$2
CONFIG=$1

set -e
for job in ${DIR}/*
do
    ./scripts/ud_job.sh ${CONFIG} update ${job}
done
