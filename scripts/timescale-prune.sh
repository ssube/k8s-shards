#! /bin/bash

source "$(dirname ${BASH_SOURCE[0]})/common.sh"

###
# timescale prune
#
# remove old chunks
###

prune_table="${1}" && shift
prune_database="${1}" && shift
prune_domain="${1}" && shift
prune_hours="${1:-30 days}"
prune_query="SELECT drop_chunks(interval '${prune_hours}', '${prune_table}', cascade_to_materializations=>TRUE);"

echo_color start "Pruning chunks older than ${prune_hours}"

echo_color info "Finding pod for ${prune_domain}/timescale-role=server"
timescale_pod="$(find_pod server monitor ${prune_domain}/timescale-role)"
echo_color info "Running query in pod: ${timescale_pod}"
kubectl exec -n monitor ${timescale_pod} -it -- psql -U postgres -d ${prune_database} -c "${prune_query}"

echo_color success "Pruned chunks"
