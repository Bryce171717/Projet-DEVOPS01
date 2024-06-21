from pyspark.sql import SparkSession

spark = SparkSession.builder \
    .appName("Hello World PySpark") \
    .getOrCreate()

data = [("Hello", "World")]
df = spark.createDataFrame(data, ["Column1", "Column2"])
df.show()

spark.stop()
