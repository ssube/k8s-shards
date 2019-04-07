#! /bin/bash

source "$(dirname ${BASH_SOURCE[0]})/common.sh"

###
# create an STS session and set the environment
###

account="${1}" && shift
duration="${1:-3600}"
role_arn="${2:-arn:aws:iam::${account}:role/root-caa}"

unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

session="$(aws sts assume-role --role-arn ${role_arn} --role-session-name test-session --duration-seconds ${duration})"
echo "export AWS_ACCESS_KEY_ID=$(echo "${session}" | jq .Credentials.AccessKeyId)"
echo "export AWS_SECRET_ACCESS_KEY=$(echo "${session}" | jq .Credentials.SecretAccessKey)"
echo "export AWS_SESSION_TOKEN=$(echo "${session}" | jq .Credentials.SessionToken)"
