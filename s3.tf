# #https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
#https://www.milanvit.net/post/terraform-recipes-cloudfront-distribution-from-s3-bucket/

resource "aws_s3_bucket" "decouplecontent" {
  bucket = "vivianbucket1278094"   
  
  tags = {
    Name        = "edge-content_823"
    Environment = "dev"
  }

}

resource "aws_s3_bucket_acl" "decouple-content" {
  bucket = aws_s3_bucket.decouplecontent.id
  acl    = "public-read"
}


###################################
# S3 Bucket Policy
###################################
resource "aws_s3_bucket_policy" "edge_content" {
  bucket = aws_s3_bucket.decouplecontent.id
  policy = data.aws_iam_policy_document.edge_content_bucket.json
}

data "aws_iam_policy_document" "allow_access_from_another_account" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["1234567890125"]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.decouplecontent.arn,
      "${aws_s3_bucket.decouplecontent.arn}/*",
    ]
  }
}

###################################
# S3 Bucket Public Access Block
###################################
resource "aws_s3_bucket_public_access_block" "edge_content_access" {
  bucket = aws_s3_bucket.decouplecontent.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = false
}


