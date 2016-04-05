#!/bin/bash

apt-get install -y libyaml-dev python-pip python-dev libxml2-dev libxslt-dev
pip install jenkins-job-builder==1.4.0 jenkins-job-wrecker==1.0.3
pip install pbr
pip install multi_key_dict
