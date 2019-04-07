#! /bin/bash

source "$(dirname ${BASH_SOURCE[0]})/common.sh"

###
# timescale prune
#
# remove old chunks
###

prune_table="${1}" && shift
prune_domain="${1}" && shift
prune_hours="${1:-12 hours}"
prune_query="SELECT drop_chunks(interval '${prune_hours}', '${prune_table}');"

echo_color start "Pruning chunks older than ${prune_hours}"

# TODO: validate prune_hours is a number
timescale_pod="$(find_pod server monitor "${prune_domain}/timescale")"
echo_color info "Running query in pod: ${timescale_pod}"
kubectl exec -n monitor ${timescale_pod} -it -- psql -U postgres -d prometheus -c "${prune_query}"

echo_color success "Pruned chunks"