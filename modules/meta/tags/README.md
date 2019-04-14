# Meta Tags

Generates project and account tags for resources.

## Module

Pass as `tag_` variables:

```terraform
tag_account     = "${module.robots_tags.tag_account}"
tag_environment = "${module.robots_tags.tag_environment}"
tag_owner       = "${module.robots_tags.tag_owner}"
tag_project     = "${module.robots_tags.tag_project}"
```

## Resource

Pass as `tags` block:

```terraform
tags {
  account     = "${module.home_tags.tag_account}"
  environment = "${module.home_tags.tag_environment}"
  owner       = "${module.home_tags.tag_owner}"
  project     = "${module.home_tags.tag_project}"
}
```