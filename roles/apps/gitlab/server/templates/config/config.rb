external_url 'https://git.{{ secrets.dns.base }}'

gitlab_rails['gitlab_username_changing_enabled'] = false
gitlab_rails['webhook_timeout'] = 2

# defaults
gitlab_rails['gitlab_default_can_create_group'] = false
gitlab_rails['gitlab_default_projects_features_issues'] = true
gitlab_rails['gitlab_default_projects_features_merge_requests'] = true
gitlab_rails['gitlab_default_projects_features_wiki'] = true
gitlab_rails['gitlab_default_projects_features_snippets'] = false
gitlab_rails['gitlab_default_projects_features_builds'] = true
gitlab_rails['gitlab_default_projects_features_container_registry'] = false

# gravatar
gitlab_rails['gravatar_plain_url'] = 'http://www.gravatar.com/avatar/%{hash}?s=%{size}&d=identicon'
gitlab_rails['gravatar_ssl_url'] = 'https://secure.gravatar.com/avatar/%{hash}?s=%{size}&d=identicon'

# email
gitlab_rails['gitlab_email_enabled'] = true
gitlab_rails['incoming_email_enabled'] = false

gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.gmail.com"
gitlab_rails['smtp_port'] = 587
gitlab_rails['smtp_from'] = "{{ secrets.gitlab.email.user }}"
gitlab_rails['smtp_user_name'] = "{{ secrets.gitlab.email.user }}"
gitlab_rails['smtp_password'] = "{{ secrets.gitlab.email.pass }}"
gitlab_rails['smtp_domain'] = "smtp.gmail.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = false
gitlab_rails['smtp_openssl_verify_mode'] = 'peer'

# artifacts
gitlab_rails['artifacts_enabled'] = true
gitlab_rails['artifacts_path'] = "{{ secrets.gitlab.data }}/artifacts"

# lfs
gitlab_rails['lfs_enabled'] = false

# pages
gitlab_rails['pages_path'] = "{{ secrets.gitlab.data }}/pages"

# ldap
gitlab_rails['ldap_enabled'] = false

# backups
gitlab_rails['manage_backup_path'] = true
gitlab_rails['backup_path'] = "{{ secrets.gitlab.data }}/backups"
gitlab_rails['backup_archive_permissions'] = 0644
gitlab_rails['backup_pg_schema'] = 'public'
gitlab_rails['backup_keep_time'] = 604800
gitlab_rails['backup_upload_connection'] = {
  'provider'          => 'AWS',
  'region'            => '{{ secrets.aws.region.primary }}',
  'aws_access_key_id' => '{{ secrets.aws.user.backup.access_key }}',
  'aws_secret_access_key' => '{{ secrets.aws.user.backup.secret_key }}'
}
gitlab_rails['backup_upload_remote_directory'] = '{{ secrets.gitlab.backup.bucket }}'

# data
git_data_dirs({
  "default" => {
    "path" => "{{ secrets.gitlab.data }}"
  }
})

gitlab_rails['shared_path'] = '{{ secrets.gitlab.data }}/shared'

# database
postgresql['enable'] = false

gitlab_rails['db_adapter'] = "postgresql"
gitlab_rails['db_encoding'] = "unicode"
gitlab_rails['db_database'] = "{{ secrets.gitlab.database.name }}"
gitlab_rails['db_pool'] = 20
gitlab_rails['db_username'] = "{{ secrets.gitlab.database.user }}"
gitlab_rails['db_password'] = "{{ secrets.gitlab.database.pass }}"
gitlab_rails['db_host'] = "postgres-{{ secrets.gitlab.database.name }}.gitlab.svc.{{ secrets.dns.cluster }}.{{ secrets.dns.base }}"
gitlab_rails['db_port'] = 5432

# nginx
nginx['enable'] = false

# workhorse
gitlab_workhorse['listen_network'] = "tcp"
gitlab_workhorse['listen_addr'] = "0.0.0.0:8181"

# kubernetes
gitlab_rails['trusted_proxies'] = ['127.0.0.0/8', '10.0.0.0/8', '100.0.0.0/8']
gitlab_rails['monitoring_whitelist'] = ['0.0.0.0/0', '127.0.0.0/8', '10.0.0.0/8', '100.0.0.0/8']

# monitor
gitlab_monitor['enable'] = true

# prometheus
prometheus['enable'] = false

# redis
redis['enable'] = false

gitlab_rails['redis_host'] = "redis-gitlab.gitlab.svc.{{ secrets.dns.cluster }}.{{ secrets.dns.base }}"
gitlab_rails['redis_port'] = 6379

# shell
gitlab_rails['gitlab_shell_ssh_port'] = 22
gitlab_shell['audit_usernames'] = true
gitlab_shell['auth_file'] = "{{secrets.gitlab.data}}/ssh/authorized_keys"