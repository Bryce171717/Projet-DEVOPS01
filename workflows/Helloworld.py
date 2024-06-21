from pyspark.sql import SparkSession

# Création d'une session Spark
spark = SparkSession.builder \
    .appName("Hello World PySpark") \
    .getOrCreate()

# Création d'un DataFrame simple
data = [("Hello", "World")]
columns = ["Colonne1", "Colonne2"]
df = spark.createDataFrame(data, columns)

# Affichage du contenu du DataFrame
df.show()

# Arrêt de la session Spark
spark.stop()