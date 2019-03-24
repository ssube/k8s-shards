# k8s-shards

Useful roles, snippets, and YAMLs for kube.

Secrets and playbooks are not provided, these are fragments pulled from the various clusters I maintain. While mildly
organized, this is as much for my reference as anything.

## Playbook

To use these roles in a playbook, install them with galaxy or clone them into a submodule, then add `roles/` to the
`roles_path` and the plugins. For example, in `ansible.cfg`, add:

```
[defaults]
action_plugins = ./plugins/actions:../vendor/k8s-shards/plugins/actions
filter_plugins = ./plugins/filters:../vendor/k8s-shards/plugins/filters
roles_path = ./roles:../vendor/k8s-shards/roles
```

## Variables

Two variables must be provided: `secrets` as the root secret and `shards` as the root for everything else.
