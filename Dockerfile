# Utilise une image Python slim
FROM python:3.8-slim

# Installation de PySpark
RUN pip install pyspark

# Ajout du code de l'application dans le conteneur
COPY Helloworld.py /app/Helloworld.py

# Définir le répertoire de travail
WORKDIR /app

# Commande pour exécuter l'application
CMD ["python", "Helloworld.py"]
