resource "snowflake_storage_integration_aws" "s3_integration" {
  name             = "ETL_S3_INTEGRATION_DEV"
  enabled          = true
  storage_provider = "S3"

  storage_aws_role_arn = aws_iam_role.snowflake_storage_role.arn

  storage_allowed_locations = [
    "s3://${aws_s3_bucket.etl_bucket.bucket}/curated/"
  ]

  comment = "Storage integration allowing Snowflake to access curated ETL data in S3"
}

resource "snowflake_stage_external_s3" "orders_stage" {
  name     = "ORDERS_S3_STAGE"
  database = snowflake_database.etl_database.name
  schema   = snowflake_schema.raw.name

  url = "s3://${aws_s3_bucket.etl_bucket.bucket}/curated/orders/"

  storage_integration = snowflake_storage_integration_aws.s3_integration.name

  file_format {
    format_name = snowflake_file_format_parquet.orders_parquet.fully_qualified_name
  }

  comment = "External S3 stage for curated order Parquet files"
}