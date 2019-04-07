#! /bin/bash

source "$(dirname ${BASH_SOURCE[0]})/common.sh"

###
# nexus init container script
###

data_path="${1}"
echo_color info "data path: ${data_path}"

if [[ ! -d "${data_path}" ]];
then
  mkdir -p "${data_path}"
fi

chown -R 200:200 "${data_path}"
ls -lha "${data_path}"

echo_color success "init complete"
