# Utiliser une image de base Python
FROM python:3.8-slim

# Installer Java pour PySpark
RUN apt-get update && apt-get install -y openjdk-17-jdk-headless procps && rm -rf /var/lib/apt/lists/*

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de l'application
COPY hello_world.py /app/

# Installer les dépendances Python
RUN pip install pyspark pymongo

# Commande pour exécuter l'application
CMD ["python", "hello_world.py"]