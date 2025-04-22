resource "aws_s3_bucket" "chartmuseum" {
  bucket = format("%s-%s-chartmuseum", var.project_name, data.aws_caller_identity.current.account_id)
}

resource "aws_s3_bucket_ownership_controls" "chartmuseum" {
  bucket = aws_s3_bucket.chartmuseum.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "chartmuseum" {
  bucket = aws_s3_bucket.chartmuseum.id
  acl    = "private"

  depends_on = [
    aws_s3_bucket_ownership_controls.chartmuseum
  ]
}

resource "aws_s3_object" "linuxtips" {
  bucket = aws_s3_bucket.chartmuseum.id
  key    = "linuxtips-0.1.0.tgz"
  source = "${path.module}/helm/linuxtips-0.1.0.tgz"
  etag   = filemd5("${path.module}/helm/linuxtips-0.1.0.tgz")
}