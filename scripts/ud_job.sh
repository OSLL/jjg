#!/bin/bash

SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`
TEMPLATE_VIEW_PATH=$SCRIPTPATH/view_template.xml

function prop {
  grep "${1}=" ${JENKINS_CONFIG}|cut -d'=' -f2
}

function add_job_to_view {
  JOB_NAME=`echo $YAML_JOB | grep -o -P '\w*(?=.yaml)'`
  if ! java -jar "$HOME/jenkins-cli.jar" -s $(prop 'url') -auth $(prop 'user'):$(prop 'password') add-job-to-view "${1}" "$JOB_NAME"; then
    echo "ERROR: job - '$JOB_NAME' adding to view '${1}' failed!"
  else
    echo "SUCCESS: job - '$JOB_NAME' has been added to view - '${1}'"
  fi
}

view_name=""
function is_view_exist {
  java -jar "$HOME/jenkins-cli.jar" -s $(prop 'url') -auth $(prop 'user'):$(prop 'password') get-view "$view_name" &>/dev/null
}

function create_view {
  cp $TEMPLATE_VIEW_PATH $TEMPLATE_VIEW_PATH.temp
  sed -i "s|#{VIEW_NAME}|$view_name|g" $TEMPLATE_VIEW_PATH.temp

  if ! java -jar "$HOME/jenkins-cli.jar" -s $(prop 'url') -auth $(prop 'user'):$(prop 'password') create-view "$view_name" < $TEMPLATE_VIEW_PATH.temp; then
    echo "ERROR: view - '$view_name' creation failed!"
  else
    echo "SUCCESS: view - '$view_name' has been created"
  fi
  rm $TEMPLATE_VIEW_PATH.temp
}

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
GIT_BRANCH=$(git branch | grep '*' | sed "s/[*]//")
TAG="[${TIMESTAMP} ID=${GIT_ID} GITBRANCH=${GIT_BRANCH} PATH=${YAML_JOB}]"

echo "Timestamp: "${TIMESTAMP}", Git ID: "${GIT_ID}
echo "PATH: "${YAML_JOB}", GIT BRANCH: "${GIT_BRANCH}
echo ${TAG}

if grep -q "^    description:\s*" ${YAML_JOB}"_temp"; then
  sed -i -e "s|^    description[^']*'[^']*|& \n\r${TAG}\n\r|" ${YAML_JOB}_temp
  echo "description modified"
else
  sed -i -e "3i\ \ \ \ description:  '${TAG}\n\r'" ${YAML_JOB}_temp
  echo "description added"
fi

jenkins-jobs --conf ${JENKINS_CONFIG} ${ACTION} ${YAML_JOB}_temp
res=$?

view_name=`grep "description:" ${YAML_JOB}"_temp" | grep -o -P '(?<=View:)\s*(\w*)(?=.)' | grep -o -P '[^\s]+'`

if [[ -n "${view_name// }" ]]; then
  if ! $(is_view_exist); then
    create_view $view_name
  fi
  add_job_to_view $view_name
fi

cat  ${YAML_JOB}_temp

exit $res