@echo off
REM Script de vérification de l'installation (Windows)

echo.
echo ==========================================
echo Verification de l'Installation GestionRDV
echo ==========================================
echo.

setlocal enabledelayedexpansion

set files_found=0
set files_missing=0

echo Verification des dossiers...
if exist "src" (echo [OK] src/) else (echo [MANQUANT] src/ && set /A files_missing+=1)
if exist "src\models" (echo [OK] src\models\) else (echo [MANQUANT] src\models\ && set /A files_missing+=1)
if exist "WebContent" (echo [OK] WebContent\) else (echo [MANQUANT] WebContent\ && set /A files_missing+=1)
if exist "WebContent\WEB-INF" (echo [OK] WebContent\WEB-INF\) else (echo [MANQUANT] WebContent\WEB-INF\ && set /A files_missing+=1)

echo.
echo Verification des fichiers Java...
if exist "src\models\Patient.java" (echo [OK] src\models\Patient.java) else (echo [MANQUANT] && set /A files_missing+=1)
if exist "src\models\Medecin.java" (echo [OK] src\models\Medecin.java) else (echo [MANQUANT] && set /A files_missing+=1)
if exist "src\models\RDV.java" (echo [OK] src\models\RDV.java) else (echo [MANQUANT] && set /A files_missing+=1)
if exist "src\dao\PatientDAO.java" (echo [OK] src\dao\PatientDAO.java) else (echo [MANQUANT] && set /A files_missing+=1)
if exist "src\dao\MedecinDAO.java" (echo [OK] src\dao\MedecinDAO.java) else (echo [MANQUANT] && set /A files_missing+=1)
if exist "src\dao\RDVDAO.java" (echo [OK] src\dao\RDVDAO.java) else (echo [MANQUANT] && set /A files_missing+=1)

echo.
echo Verification des pages JSP...
if exist "WebContent\index.jsp" (echo [OK] index.jsp) else (echo [MANQUANT] && set /A files_missing+=1)
if exist "WebContent\login-patient.jsp" (echo [OK] login-patient.jsp) else (echo [MANQUANT] && set /A files_missing+=1)
if exist "WebContent\patient-dashboard.jsp" (echo [OK] patient-dashboard.jsp) else (echo [MANQUANT] && set /A files_missing+=1)

echo.
echo Verification de la base de donnees...
if exist "base_donnees.sql" (echo [OK] base_donnees.sql) else (echo [MANQUANT] && set /A files_missing+=1)

echo.
echo ==========================================
if %files_missing% equ 0 (
    echo Installation complete!
    echo.
    echo Prochaines etapes:
    echo 1. Importer base_donnees.sql dans MySQL
    echo 2. Telecharger mysql-connector-java-5.1.49.jar
    echo 3. Placer dans WebContent\WEB-INF\lib\
    echo 4. Copier le dossier dans C:\xampp\tomcat\webapps\
    echo 5. Acceder a http://localhost:8080/GestionRDV/
) else (
    echo Installation incomplete! Fichiers manquants: %files_missing%
)
echo ==========================================
echo.
pause
