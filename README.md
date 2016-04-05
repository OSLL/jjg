# jenkins_job_gitizer
Wrapper around jenkins-job-builder (https://github.com/openstack-infra/jenkins-job-builder)

# content

* ./scripts Wrapping scripts
  * setup_environment.sh - setup dependencies for this project (require sudo)
  * setup_git_sync_target.sh - setup syncronization between git repo with jobs and jenkins instance 
  * sync_jobs.sh - updates (creates) jobs on jenkins from yaml stored at DIR
  * validate_yaml.sh - validate \*.yaml file structure
  * validate_jobs.sh - validate all jobs stored at DIR
  * ud_job.sh - update/delete job on remote Jenkins using yaml description
* ./test_configs - configs for testing 
  * jenkins.ini - config for mdbci project jenkins
* ./test_jobs - example jobs
  * ./test_jobs/simplest_job/test_job.yaml - hello world parametrized job
  * ./test_jobs/includes/ - job where set of parameter values are stored at separated file

# installation 

<pre>
sudo ./scripts/setup_environment.sh
</pre>

Copy ./test_configs/jenkins.ini.template to ./test_configs/jenkins.ini and put path to your Jenkins 
and its credentials to this file

# usage

Checking yaml validity
<pre>
./scripts/validate_yaml.sh test_jobs/includes/jjb_parameter_set_defined_in_include.yaml
</pre>

Updating job on server
<pre>
./scripts/ud_job.sh test_configs/jenkins.ini update test_jobs/includes/jjb_parameter_set_defined_in_include.yaml
./scripts/ud_job.sh test_configs/jenkins.ini update test_jobs/template/jjb_project.yaml
./scripts/ud_job.sh test_configs/jenkins.ini update test_jobs/macros/jjb-macros.yaml
</pre>

Job git syncing setup
<pre>
./scripts/setup_git_sync_target.sh test_configs/jenkins.ini git@github.com:OSLL/jjg_example_job_repo.git
</pre>

# Job git syncing setup - manual

Prerequisites: JOBS_REPO_URL - git repository where job descriptions in yaml format are stored at "jobs" directory.

1. Clone this repo localy, ensure that user by which jenkins is executed has enough  rights for runnig scripts from the repo.
2. Create jenkins account for performing jobs creation and update.
3. Create ini file (test_configs/*.template) for jenkins account created previously.
4. Ensure that repository JOBS_REPO_URL is accesseble from jenkins server.
5. Run ./scripts/setup_git_sync_target.sh
<pre>
./scripts/setup_git_sync_target.sh CONFIG JOBS_REPO_URL
</pre>
If all steps are performed successfuly new target "Jobs_git_synchronization" should appear at jenkins server.
