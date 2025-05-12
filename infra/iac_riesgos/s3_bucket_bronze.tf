resource "aws_s3_bucket" "bronze_bucket" {
  bucket = "zona-bronce-datos-riesgos"
  force_destroy = true
  tags = {
    Proyecto    = "riesgos"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_privado" {
  bucket = aws_s3_bucket.bronze_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}