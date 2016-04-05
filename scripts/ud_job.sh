#!/bin/bash

JENKINS_CONFIG=$1
ACTION=$2 # update/ delete 
YAML_JOB=$3



jenkins-jobs --conf ${JENKINS_CONFIG} ${ACTION} ${YAML_JOB}
