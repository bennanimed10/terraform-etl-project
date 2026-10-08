resource "aws_iam_role" "glue_etl_role" {
  name = "terraform-etl-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "glue.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = "dev"
    Project     = "terraform-etl-project"
    ManagedBy   = "Terraform"
  }
}
resource "aws_iam_role_policy" "glue_s3_policy" {
  name = "terraform-etl-glue-s3-policy"
  role = aws_iam_role.glue_etl_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.etl_bucket.arn
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = [
          "${aws_s3_bucket.etl_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role" "snowflake_storage_role" {
  name = "terraform-snowflake-storage-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = "dev"
    Project     = "terraform-etl-project"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role" "snowflake_storage_role" {
  name = "terraform-snowflake-storage-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = "dev"
    Project     = "terraform-etl-project"
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_role_policy" "snowflake_s3_policy" {
  name = "terraform-snowflake-s3-policy"
  role = aws_iam_role.snowflake_storage_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.etl_bucket.arn
        ]

        Condition = {
          StringLike = {
            "s3:prefix" = [
              "curated/*"
            ]
          }
        }
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]

        Resource = [
          "${aws_s3_bucket.etl_bucket.arn}/curated/*"
        ]
      }
    ]
  })
}