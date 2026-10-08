from pyspark.sql import SparkSession
from pyspark.sql.functions import col

spark = SparkSession.builder.getOrCreate()

input_path = "s3://my-terraform-etl-learning-bucket/landing/orders/"
output_path = "s3://my-terraform-etl-learning-bucket/curated/orders/"

df_orders = (
    spark.read
    .option("header", "true")
    .csv(input_path)
)

df_transformed = (
    df_orders
    .withColumn("quantity", col("quantity").cast("int"))
    .withColumn("unit_price", col("unit_price").cast("double"))
    .withColumn(
        "total_amount",
        col("quantity") * col("unit_price")
    )
)

(
    df_transformed.write
    .mode("overwrite")
    .parquet(output_path)
)

