from pyspark.sql import SparkSession
import pytest

def test_spark_session():
    spark = SparkSession.builder.appName("Test").getOrCreate()
    assert spark is not None
    spark.stop()

def test_data_frame():
    spark = SparkSession.builder.appName("Test").getOrCreate()
    data = [("Hello", "World")]
    df = spark.createDataFrame(data, ["Column1", "Column2"])
    assert df.count() == 1
    spark.stop()
