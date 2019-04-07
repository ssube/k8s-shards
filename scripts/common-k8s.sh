#! /bin/bash

# K8s helpers
function cp_from_pod() {
  pod=${1} && shift

  kubectl cp ${pod}:${@}
}

function delete_pod() {
  pod=${1}

  kubectl delete pod ${pod}
}

# TODO: add a namespace parameter
function exec_in_pod() {
  pod=${1} && shift
  cmd=${1} && shift
  args=${@}

  kubectl exec ${pod} -it -- ${cmd} ${args}
}

function exec_in_ns_pod() {
	local ns=${1} && shift
  local pod=${1} && shift
  local cmd=${1} && shift
  local args="${@}"

	echo "${args}"
  kubectl exec -n ${ns} ${pod} -it -- ${cmd} ${args}
}

# TODO: put namespace first
function find_pod() {
  name=${1}
  namespace=${2:-default}
  label=${3:-k8s-app}

  pod="$(kubectl get pods -l ${label}=${name} -n ${namespace} -o jsonpath='{.items[0].metadata.name}' | head -1)"

  echo ${pod}
}

function cluster_usage() {
	local node_count=0
	local total_percent_cpu=0
	local total_percent_mem=0
	local nodes=$(kubectl get nodes --no-headers -o custom-columns=NAME:.metadata.name)

	for n in $nodes; do
		local requests=$(kubectl describe node $n | grep -A2 -E "^\\s*CPU Requests" | tail -n1)
		local percent_cpu=$(echo $requests | awk -F "[()%]" '{print $2}')
		local percent_mem=$(echo $requests | awk -F "[()%]" '{print $8}')
		echo "$n: ${percent_cpu}% CPU, ${percent_mem}% memory"

		node_count=$((node_count + 1))
		total_percent_cpu=$((total_percent_cpu + percent_cpu))
		total_percent_mem=$((total_percent_mem + percent_mem))
	done

	local readonly avg_percent_cpu=$((total_percent_cpu / node_count))
	local readonly avg_percent_mem=$((total_percent_mem / node_count))

	echo "Average usage: ${avg_percent_cpu}% CPU, ${avg_percent_mem}% memory."
}