#! /bin/bash

source "$(dirname ${BASH_SOURCE[0]})/common.sh"

###
# cluster validation script
###

nodes="$(kubectl get nodes | head -n +1 | awk '{ print $3; }')"

# for each node
# 
#   reboot it
#     systemctl? isp api?
#   validate cluster
#   while false
#     validate again