output "s3_bucket_name" {
  description = "Name of the ETL S3 bucket"
  value       = aws_s3_bucket.etl_bucket.bucket
}