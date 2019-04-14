resource "aws_s3_bucket" "site_primary" {
  bucket = "${var.site_name}-primary"
  acl    = "public-read"

  website {
    error_document = "404.html"
    index_document = "index.html"
  }

  tags {
    account     = "${var.tag_account}"
    environment = "${var.tag_environment}"
    owner       = "${var.tag_owner}"
    project     = "${var.tag_project}"
  }
}

resource "aws_s3_bucket" "site_draft" {
  bucket = "${var.site_name}-draft"
  acl    = "public-read"

  website {
    error_document = "404.html"
    index_document = "index.html"
  }

  tags {
    account     = "${var.tag_account}"
    environment = "${var.tag_environment}"
    owner       = "${var.tag_owner}"
    project     = "${var.tag_project}"
  }
}

resource "aws_s3_bucket_policy" "site_policy" {
  bucket = "${aws_s3_bucket.site_primary.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "${var.site_name}-read",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "${aws_s3_bucket.site_primary.arn}",
        "${aws_s3_bucket.site_primary.arn}/*"
      ]
    } 
  ]
}
POLICY
}

resource "aws_cloudfront_distribution" "site_dist" {
  origin {
    domain_name = "${aws_s3_bucket.site_primary.website_endpoint}"
    origin_id   = "S3-site-posts"

    custom_origin_config {
      http_port  = "80"
      https_port = "443"

      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  aliases             = ["${var.site_aliases}"]
  enabled             = true
  is_ipv6_enabled     = true
  comment             = ""
  default_root_object = "index.html"

  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = "404"
    response_code         = "404"
    response_page_path    = "/404.html"
  }

  default_cache_behavior {
    allowed_methods  = ["HEAD", "GET"]
    cached_methods   = ["HEAD", "GET"]
    target_origin_id = "S3-site-posts"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn      = "${var.site_cert}"
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }

  tags {
    account     = "${var.tag_account}"
    environment = "${var.tag_environment}"
    owner       = "${var.tag_owner}"
    project     = "${var.tag_project}"
  }
}
