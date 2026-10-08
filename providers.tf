terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    snowflake = {
      source  = "snowflakedb/snowflake"
      version = "~> 2.21"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "snowflake" {
}