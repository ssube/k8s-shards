variable "site_aliases" {
  type = "list"
}

variable "site_cert" {}
variable "site_name" {}

variable "tag_account" {}
variable "tag_environment" {}
variable "tag_project" {}
variable "tag_owner" {}

output "dist_domain" {
  value = "${aws_cloudfront_distribution.site_dist.domain_name}"
}

output "dist_zone" {
  value = "${aws_cloudfront_distribution.site_dist.hosted_zone_id}"
}
