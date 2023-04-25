#!/usr/bin/env bash

# Sends the given file to the Jenkins server for validation.
#
# Requires environment variables:
# JENKINS_USERNAME with the jenkins username
# JENKINS_BASE_URL with the jenkins base url. Example https://jenkins.my-company.de

readonly JENKINS_FILE_PATH=$1
# curl will prompt for the jenkins password of the user
curl --insecure -su "$JENKINS_USERNAME" -X POST -F "jenkinsfile=<$JENKINS_FILE_PATH" "$JENKINS_BASE_URL"/pipeline-model-converter/validate


