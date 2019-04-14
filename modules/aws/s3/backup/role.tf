data "aws_iam_policy_document" "replication_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals = [
      "s3.amazonaws.com"
    ]

    effect = "Allow"
  }
}

resource "aws_iam_role" "replication" {
  name = "${var.bucket_name}-replication"

  assume_role_policy = "${data.aws_iam_policy_document.replication_policy.json}"
}

