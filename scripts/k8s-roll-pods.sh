DEFAULT_POD_FILTER="--all-namespaces"
DEFAULT_POD_INTERVAL=6

POD_FILTER=${1:-${DEFAULT_POD_FILTER}}
POD_INTERVAL=${2:-${DEFAULT_POD_INTERVAL}}

POD_RESULTS="$(kubectl get pods ${POD_FILTER} | grep -v etcd | awk '{ print $1 " " $2; }' | sed -n '1!p')"
POD_COLUMNS="$(echo "${POD_RESULTS}" | column -t -s ' ')"

echo "Pods:\n${POD_COLUMNS}"

echo "$(echo "${POD_RESULTS}" | awk "{ print \"k delete pod -n \" \$1 \" \" \$2 \" && sleep ${POD_INTERVAL}\"; }")"