#!/bin/bash
# Script de vérification de l'installation

echo "=========================================="
echo "Vérification de l'Installation GestionRDV"
echo "=========================================="
echo ""

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Compteurs
files_found=0
files_missing=0

# Fonction de vérification
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((files_found++))
    else
        echo -e "${RED}✗${NC} $1 (MANQUANT)"
        ((files_missing++))
    fi
}

# Fonction de vérification dossier
check_dir() {
    if [ -d "$1" ]; then
        echo -e "${GREEN}✓${NC} $1/"
        ((files_found++))
    else
        echo -e "${RED}✗${NC} $1/ (MANQUANT)"
        ((files_missing++))
    fi
}

echo "Vérification des dossiers..."
check_dir "src"
check_dir "src/models"
check_dir "src/dao"
check_dir "src/utils"
check_dir "WebContent"
check_dir "WebContent/WEB-INF"
check_dir "WebContent/WEB-INF/lib"
check_dir "WebContent/css"
check_dir "WebContent/js"

echo ""
echo "Vérification des fichiers Java..."
check_file "src/models/Patient.java"
check_file "src/models/Medecin.java"
check_file "src/models/RDV.java"
check_file "src/dao/PatientDAO.java"
check_file "src/dao/MedecinDAO.java"
check_file "src/dao/RDVDAO.java"
check_file "src/utils/DBConnection.java"
check_file "src/utils/EmailUtil.java"

echo ""
echo "Vérification des pages JSP..."
check_file "WebContent/index.jsp"
check_file "WebContent/login-patient.jsp"
check_file "WebContent/login-medecin.jsp"
check_file "WebContent/patient-dashboard.jsp"
check_file "WebContent/medecin-dashboard.jsp"
check_file "WebContent/logout.jsp"
check_file "WebContent/get-timeslots.jsp"

echo ""
echo "Vérification de la configuration..."
check_file "WebContent/WEB-INF/web.xml"
check_file "WebContent/css/style.css"
check_file "WebContent/js/script.js"

echo ""
echo "Vérification des fichiers de configuration..."
check_file ".project"
check_file ".classpath"

echo ""
echo "Vérification de la base de données..."
check_file "base_donnees.sql"

echo ""
echo "Vérification de la documentation..."
check_file "README.md"
check_file "DEMARRAGE_RAPIDE.md"
check_file "INSTALLATION_TOMCAT.md"
check_file "ECLIPSE_CONFIGURATION.md"
check_file "RESUME_PROJET.md"
check_file "URLs_NAVIGATION.md"

echo ""
echo "Vérification des scripts..."
check_file "deploy.sh"
check_file "deploy.bat"

echo ""
echo "=========================================="
echo "Résultats:"
echo -e "${GREEN}✓ Fichiers trouvés: $files_found${NC}"
echo -e "${RED}✗ Fichiers manquants: $files_missing${NC}"
echo "=========================================="

if [ $files_missing -eq 0 ]; then
    echo -e "${GREEN}✓ Installation complète!${NC}"
    echo ""
    echo "Prochaines étapes:"
    echo "1. Importer base_donnees.sql dans MySQL"
    echo "2. Télécharger mysql-connector-java-5.1.49.jar"
    echo "3. Placer dans WebContent/WEB-INF/lib/"
    echo "4. Copier le dossier dans tomcat/webapps/"
    echo "5. Accéder à http://localhost:8080/GestionRDV/"
else
    echo -e "${RED}✗ Installation incomplète! Fichiers manquants: $files_missing${NC}"
    echo "Veuillez télécharger les fichiers manquants."
fi

echo ""
