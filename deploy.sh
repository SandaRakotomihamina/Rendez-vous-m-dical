#!/bin/bash

# Script de configuration et déploiement du projet GestionRDV
# Usage: ./deploy.sh

echo "=========================================="
echo "Configuration du Projet GestionRDV"
echo "=========================================="

# Vérifier si les répertoires existent
if [ ! -d "WebContent/WEB-INF/classes" ]; then
    echo "Création du répertoire classes..."
    mkdir -p WebContent/WEB-INF/classes
fi

# Compilation des fichiers Java
echo "Compilation des fichiers Java..."
javac -d WebContent/WEB-INF/classes -cp ".:WebContent/WEB-INF/lib/*" src/models/*.java src/utils/*.java src/dao/*.java 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Compilation réussie"
else
    echo "✗ Erreur de compilation"
    echo "Assurez-vous que mysql-connector-java.jar est dans WebContent/WEB-INF/lib/"
fi

# Créer un fichier WAR pour le déploiement
echo "Création du fichier WAR..."
cd WebContent
jar -cvf ../GestionRDV.war . > /dev/null 2>&1
cd ..

echo "✓ Fichier GestionRDV.war créé"

echo ""
echo "=========================================="
echo "Configuration terminée!"
echo "=========================================="
echo ""
echo "Prochaines étapes:"
echo "1. Copier GestionRDV/ dans le répertoire webapps de Tomcat"
echo "   Ou copier GestionRDV.war dans webapps/"
echo "2. Démarrer le serveur Tomcat"
echo "3. Accéder à http://localhost:8080/GestionRDV/"
echo ""
