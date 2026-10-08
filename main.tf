resource "aws_s3_bucket" "etl_bucket" {
  bucket = var.bucket_name

  tags = {
    Environment = "dev"
    Project     = "terraform-etl-project"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_versioning" "etl_bucket_versioning" {
  bucket = aws_s3_bucket.etl_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "etl_bucket_encryption" {
  bucket = aws_s3_bucket.etl_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "etl_bucket_public_access" {
  bucket = aws_s3_bucket.etl_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}