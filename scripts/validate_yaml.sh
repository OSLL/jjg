#!/bin/bash

# This script validates single job, described in *.yaml

jenkins-jobs test $1 -o .
exit $?
