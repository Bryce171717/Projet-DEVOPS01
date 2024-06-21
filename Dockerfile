# Utilise une image Python slim
FROM python:3.8-slim

# Installation de PySpark
RUN pip install pyspark

# Ajout du code de l'application dans le conteneur
COPY Helloworld.py /app/Helloworld.py
COPY test_helloworld.py /app/test_helloworld.py

# Définir le répertoire de travail
WORKDIR /app

# Commande pour exécuter les tests puis l'application
CMD ["bash", "-c", "pytest test_helloworld.py && python Helloworld.py"]
