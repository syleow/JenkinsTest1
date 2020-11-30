#!/usr/bin/env sh

set -x
docker kill jenkins-integration
docker rm jenkins-integration
