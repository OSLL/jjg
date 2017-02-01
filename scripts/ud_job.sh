#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "Illegal number of parameters"
	echo "Usage: <path>/scripts/ud_job.sh <jenkins config path> {update|delete} <yaml file path>"
	exit 1
fi

JENKINS_CONFIG=$1
ACTION=$2 # update/ delete 
YAML_JOB=$3

cp ${YAML_JOB} ${YAML_JOB}"_temp"

TIMESTAMP=$(date --rfc-3339=seconds)
GIT_ID=$(git rev-parse HEAD)
TAG="[${TIMESTAMP} ID=${GIT_ID}]"
GIT_BRANCH=$(git branch | grep '*' | sed "s/[*]//")
PATH_AND_BRANCH_TAG="[PATH=${YAML_JOB} GIT BRANCH=${GIT_BRANCH}]"

echo "Timestamp: "${TIMESTAMP}", Git ID: "${GIT_ID}
echo "PATH: "${YAML_JOB}", GIT BRANCH: "${GIT_BRANCH}

if grep -q "^    description:\s*" ${YAML_JOB}"_temp"; then
  sed -i -e "s/^    description[^']*'[^']*/& \n\r${TAG}\n\r${PATH_AND_BRANCH_TAG}\n\r/" ${YAML_JOB}_temp
  echo "description modified"
else
  sed -i -e "3i\ \ \ \ description:  '${TAG}\n\r${PATH_AND_BRANCH_TAG}\n\r'" ${YAML_JOB}_temp
  echo "description added"
fi

jenkins-jobs --conf ${JENKINS_CONFIG} ${ACTION} ${YAML_JOB}_temp
res=$?

cat  ${YAML_JOB}_temp

exit $res
