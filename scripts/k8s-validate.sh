#! /bin/bash

source "$(dirname ${BASH_SOURCE[0]})/common.sh"

###
# cluster validation script
###

# args
wait="${1:-}"

function validate() {
  nodes="$(kubectl get nodes | awk '{ if (NR>1) print $1 " " $2; }')"
  while read -r node;
  do
    name="$(echo "${node}" | awk '{ print $1; }')"
    status="$(echo "${node}" | awk '{ print $2; }')"

    echo "node ${name} is ${status}"

    if [[ "${status}" != "Ready" ]];
    then
      return 1
    fi
  done <<< "${nodes}"
}

if [[ "${wait}" == "--wait" ]];
then
  valid=false
  while [[ ${valid} == false ]];
  do
    validate
    valid=${?}
  done
else
  validate
fi

echo "all nodes are ready"