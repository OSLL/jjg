#!/bin/bash

USAGE='Usage: scripts/setup_git_sync_target.sh config.ini repo_url';
# Params
#   config.ini - jenkins credentials (example test_configs/mdbci_jenkins.ini.template)
#   repo_url - git repo with yaml jobs descriptions

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters"
    echo $USAGE
    exit 1    
fi

CONFIG=$1;
REPO_URL=$2;

JOB_TEMPLATE='sync-job/jenkins_job_gitizer_sync.yaml.template';
JOB_YAML='jenkins_job_gitizer_sync.yaml';

# Steps:
# - Copy jenkins_job_gitizer_sync.yaml.template to jenkins_job_gitizer_sync.yaml
echo "Creating ${JOB_TEMPLATE} copy"
cp ${JOB_TEMPLATE} ${JOB_YAML} 

# - Embed parameters into jenkins_job_gitizer_sync.yaml
echo "Embeding parameters into ${JOB_YAML}"
JJG_PATH=`pwd`;
sed -i "s|REPO_URL|${REPO_URL}|g" ${JOB_YAML}
sed -i "s|JJG_PATH|${JJG_PATH}|g" ${JOB_YAML}

# - Create sync-job 
echo "Creating sync job from ${JOB_YAML} for ${CONFIG}"
./scripts/ud_job.sh ${CONFIG} update ${JOB_YAML}
