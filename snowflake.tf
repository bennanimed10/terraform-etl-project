resource "snowflake_database" "etl_database" {
  name    = "ETL_DEMO_DEV"
  comment = "Database for the Terraform ETL learning project"
}
resource "snowflake_schema" "raw" {
  name     = "RAW"
  database = snowflake_database.etl_database.name
  comment  = "Raw data loaded from external sources"
}

resource "snowflake_schema" "staging" {
  name     = "STAGING"
  database = snowflake_database.etl_database.name
  comment  = "Cleaned and transformed intermediate data"
}

resource "snowflake_schema" "mart" {
  name     = "MART"
  database = snowflake_database.etl_database.name
  comment  = "Business-ready analytics data"
}

resource "snowflake_warehouse" "etl_warehouse" {
  name           = "ETL_WH_DEV"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  auto_resume    = true
  comment        = "Warehouse for ETL processing"
}

resource "snowflake_table" "raw_orders" {
  database = snowflake_database.etl_database.name
  schema   = snowflake_schema.raw.name
  name     = "ORDERS"
  comment  = "Raw orders loaded from the AWS ETL pipeline"

  column {
    name     = "ORDER_ID"
    type     = "VARCHAR"
    nullable = false
  }

  column {
    name = "CUSTOMER_ID"
    type = "VARCHAR"
  }

  column {
    name = "PRODUCT_ID"
    type = "VARCHAR"
  }

  column {
    name = "QUANTITY"
    type = "NUMBER"
  }

  column {
    name = "UNIT_PRICE"
    type = "NUMBER(18,2)"
  }

  column {
    name = "TOTAL_AMOUNT"
    type = "NUMBER(18,2)"
  }

  column {
    name = "SOURCE_FILE"
    type = "VARCHAR"
  }

  column {
    name = "LOADED_AT"
    type = "TIMESTAMP_NTZ"
  }
}


resource "snowflake_file_format_parquet" "orders_parquet" {
  name        = "ORDERS_PARQUET_FF"
  database    = snowflake_database.etl_database.name
  schema      = snowflake_schema.raw.name
  compression = "AUTO"
  comment     = "Parquet file format for curated order files"
}

