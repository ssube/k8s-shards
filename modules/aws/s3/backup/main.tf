resource "aws_s3_bucket" "bucket_primary" {
  region  = "${var.region_primary}"
  bucket  = "${var.bucket_name}-primary"
  acl     = "private"

  lifecycle_rule {
    id = "retire"
    enabled = true

    prefix = "/"

    transition {
      days = "${var.transition_old}"
      storage_class = "STANDARD_IA"
    }

    transition {
      days = "${var.transition_ancient}"
      storage_class = "GLACIER"
    }
  }

  replication_configuration {
    role = "${aws_iam_role.replication.name}"

    rules {
      id = "replica"
      prefix = "/"
      status = "Enabled"

      destination {
        bucket = "${aws_s3_bucket.bucket_replica.arn}"
      }
    }
  }

  versioning {
    enabled = true
  }

  tags {
    account     = "${module.home_tags.tag_account}"
    environment = "${module.home_tags.tag_environment}"
    owner       = "${module.home_tags.tag_owner}"
    project     = "${module.home_tags.tag_project}"
  }
}

resource "aws_s3_bucket" "bucket_replica" {
  region = "${var.region_replica}"
  bucket = "${var.bucket_name}-replica"
  acl = "private"

  versioning {
    enabled = true
  }

  tags {
    account     = "${module.home_tags.tag_account}"
    environment = "${module.home_tags.tag_environment}"
    owner       = "${module.home_tags.tag_owner}"
    project     = "${module.home_tags.tag_project}"
  }
}
