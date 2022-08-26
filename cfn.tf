###################################
# CloudFront Origin Access Identity
###################################
resource "aws_cloudfront_origin_access_identity" "edge_content" {
  comment = "cloudfront-origin"
}

###################################
# IAM Policy Document
###################################
data "aws_iam_policy_document" "edge_content_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.decouplecontent.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.edge_content.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.decouplecontent.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.edge_content.iam_arn]
    }
  }
}


###################################
# CloudFront
###################################
resource "aws_cloudfront_distribution" "edge_content" {
  enabled             = true
  default_root_object = "index.html"
  # aliases             = [familybeyondcloud.com]
  # Huh? Is the next line a spoiler of a future article?
  # web_acl_id          = aws_waf_web_acl.edgecontent.id

  default_cache_behavior {
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.decouplecontent.bucket
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    min_ttl     = 0
    default_ttl = 5 * 60
    max_ttl     = 60 * 60

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }

  origin {
    domain_name = aws_s3_bucket.decouplecontent.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.decouplecontent.bucket

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.edge_content.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

viewer_certificate {
    cloudfront_default_certificate = true
  }
}
  

# aws_cloudfront_distribution.gitbook.domain_name

  #   viewer_certificate {
#     # Huh? Another spoiler?
#     acm_certificate_arn      = aws_acm_certificate_validation.cf_edgecontent.certificate_arn
#     ssl_support_method       = "sni-only"
#     minimum_protocol_version = "TLSv1.2_2018"