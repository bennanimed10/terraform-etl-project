resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.etl_bucket.id
  key    = "scripts/orders_etl.py"
  source = "${path.module}/scripts/orders_etl.py"

  etag = filemd5("${path.module}/scripts/orders_etl.py")
}

resource "aws_glue_job" "etl_job" {
  name              = "terraform-etl-glue-job"
  role_arn          = aws_iam_role.glue_etl_role.arn
  glue_version      = "5.0"
  worker_type       = "G.1X"
  number_of_workers = 2

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.etl_bucket.bucket}/${aws_s3_object.glue_script.key}"
    python_version  = "3"
  }

  tags = {
    Environment = "dev"
    Project     = "terraform-etl-project"
    ManagedBy   = "Terraform"
  }
}