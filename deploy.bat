@echo off
REM Script de configuration et déploiement du projet GestionRDV
REM Usage: deploy.bat

echo.
echo ==========================================
echo Configuration du Projet GestionRDV
echo ==========================================
echo.

REM Vérifier si le répertoire classes existe
if not exist "WebContent\WEB-INF\classes" (
    echo Création du répertoire classes...
    mkdir WebContent\WEB-INF\classes
)

REM Compilation des fichiers Java
echo Compilation des fichiers Java...
javac -d WebContent\WEB-INF\classes -cp ".;WebContent\WEB-INF\lib\*" src\models\*.java src\utils\*.java src\dao\*.java

if errorlevel 1 (
    echo ✗ Erreur de compilation
    echo Assurez-vous que mysql-connector-java.jar est dans WebContent\WEB-INF\lib\
    pause
    exit /b 1
) else (
    echo ✓ Compilation réussie
)

echo.
echo ==========================================
echo Configuration terminée!
echo ==========================================
echo.
echo Prochaines étapes:
echo 1. Copier le dossier GestionRDV dans C:\xampp\tomcat\webapps
echo 2. Démarrer le serveur Tomcat via XAMPP
echo 3. Accéder à http://localhost:8080/GestionRDV/
echo.
pause
