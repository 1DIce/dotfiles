#!/usr/bin/env bash

readonly JENKINS_FILE_PATH=$1
# curl will prompt for the jenkins password of the user
curl --insecure -su "$JENKINS_USERNAME" -X POST -F "jenkinsfile=<$JENKINS_FILE_PATH" "$JENKINS_BASE_URL"/pipeline-model-converter/validate


