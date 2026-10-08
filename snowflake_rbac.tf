resource "snowflake_account_role" "etl_loader_role" {
  name    = "ETL_LOADER_ROLE_DEV"
  comment = "Role used to load data into the RAW layer"
}

resource "snowflake_grant_privileges_to_account_role" "loader_database_usage" {
  account_role_name = snowflake_account_role.etl_loader_role.name
  privileges        = ["USAGE"]

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.etl_database.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "loader_raw_schema_usage" {
  account_role_name = snowflake_account_role.etl_loader_role.name
  privileges        = ["USAGE"]

  on_schema {
    schema_name = snowflake_schema.raw.fully_qualified_name
  }
}

resource "snowflake_grant_privileges_to_account_role" "loader_warehouse_usage" {
  account_role_name = snowflake_account_role.etl_loader_role.name
  privileges        = ["USAGE"]

  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.etl_warehouse.name
  }
}


resource "snowflake_grant_privileges_to_account_role" "loader_raw_orders" {
  account_role_name = snowflake_account_role.etl_loader_role.name
  privileges        = ["SELECT", "INSERT"]

  on_schema_object {
    object_type = "TABLE"
    object_name = snowflake_table.raw_orders.fully_qualified_name
  }
}