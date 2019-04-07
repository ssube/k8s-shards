#! /bin/bash

source "$(dirname ${BASH_SOURCE[0]})/common.sh"

###
# grafana backup script
###

# args
bucket_name="${1}" && shift

start_time="$(date +%F)"
echo_color start "Starting backup: ${start_time}"

# backup database
postgres_pod="$(find_pod postgres)"
echo_color progress "Dumping database in ${postgres_pod}"

exec_in_pod "${postgres_pod}" pg_dump -U postgres -d grafana > /tmp/grafana.sql

# backup other files?

# compress
backup_name="grafana-${start_time}"
tar -cvf /tmp/${backup_name}.tar /tmp/grafana.sql
gzip /tmp/${backup_name}.tar

# upload
echo_color progress "Uploading backup"
aws s3 cp /tmp/${backup_name}.tar.gz s3://${bucket_name}/${backup_name}.tgz

echo_color success "Finished backup: $(date)"