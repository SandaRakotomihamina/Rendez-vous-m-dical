# Gestion de Rendez-vous Médicaux en Ligne - Guide d'Installation et d'Utilisation

## Description du Projet
Application web de gestion de rendez-vous médicaux en ligne développée en JSP et MySQL. Elle permet aux patients de prendre rendez-vous avec des médecins, et aux médecins de gérer leurs consultations.

## Fonctionnalités Implémentées

### 1. **Gestion des Utilisateurs**
   - Inscription et connexion pour patients et médecins
   - Authentification sécurisée
   - Profils utilisateur distincts

### 2. **Opérations CRUD**
   - **Patients**: Création, lecture, mise à jour, suppression
   - **Médecins**: Création, lecture, mise à jour, suppression
   - **Rendez-vous**: Création, lecture, mise à jour, suppression

### 3. **Recherche Avancée**
   - Recherche de médecins par nom (LIKE %...%)
   - Filtrage par spécialité
   - Liste des médecins selon leur spécialité

### 4. **Gestion des Rendez-vous**
   - Réservation de créneaux
   - Affichage des horaires disponibles d'un médecin
   - Annulation de rendez-vous
   - Confirmation des rendez-vous
   - Vérification de la disponibilité des créneaux
   - Une horaire réservée ne peut pas être prise par d'autres patients

### 5. **Statistiques**
   - Liste des 5 médecins les plus consultés
   - Statistiques sur les rendez-vous

### 6. **Interface Moderne**
   - Interface responsive avec Bootstrap 5
   - Design attrayant et intuitif
   - Navigation facile

## Structure du Projet

```
GestionRDV/
├── WebContent/
│   ├── WEB-INF/
│   │   ├── web.xml (Configuration de l'application)
│   │   └── lib/ (Bibliothèques externes)
│   ├── index.jsp (Page d'accueil)
│   ├── login-patient.jsp (Connexion/Inscription patient)
│   ├── login-medecin.jsp (Connexion/Inscription médecin)
│   ├── patient-dashboard.jsp (Tableau de bord patient)
│   ├── medecin-dashboard.jsp (Tableau de bord médecin)
│   ├── logout.jsp (Déconnexion)
│   ├── css/
│   │   └── style.css (Feuille de styles)
│   └── js/
│       └── script.js (Scripts JavaScript)
├── src/
│   ├── models/ (Classes modèles)
│   │   ├── Patient.java
│   │   ├── Medecin.java
│   │   └── RDV.java
│   ├── dao/ (Data Access Objects)
│   │   ├── PatientDAO.java
│   │   ├── MedecinDAO.java
│   │   └── RDVDAO.java
│   └── utils/ (Classes utilitaires)
│       ├── DBConnection.java
│       └── EmailUtil.java
└── base_donnees.sql (Script SQL)
```

## Prérequis

- **Java 8+**: Pour la compilation du code JSP
- **Apache Tomcat 9.0+**: Serveur web
- **MySQL 5.7+**: Base de données
- **XAMPP**: Pour faciliter l'installation de MySQL et Apache
- **IDE**: Eclipse EE, NetBeans, ou IntelliJ IDEA

## Installation et Configuration

### Étape 1: Préparer la Base de Données

1. Ouvrir **XAMPP Control Panel** et démarrer **MySQL**
2. Accéder à **phpMyAdmin** (http://localhost/phpmyadmin)
3. Créer une nouvelle base de données:
   - Nom: `gestion_rdv`
4. Importer le fichier SQL:
   - Aller à l'onglet "Importer"
   - Sélectionner le fichier `base_donnees.sql`
   - Cliquer sur "Exécuter"

### Étape 2: Configurer le Projet JSP

1. **Copier le projet dans Tomcat**:
   ```bash
   cp -r GestionRDV $CATALINA_HOME/webapps/
   ```
   Ou utiliser un IDE pour deployer automatiquement

2. **Vérifier la configuration de la base de données**:
   - Fichier: `src/utils/DBConnection.java`
   - Paramètres:
     ```java
     private static final String URL = "jdbc:mysql://localhost:3306/gestion_rdv";
     private static final String USER = "root";
     private static final String PASSWORD = "";
     ```
   - Modifier si nécessaire selon votre configuration MySQL

3. **Ajouter le driver MySQL**:
   - Télécharger `mysql-connector-java-X.X.XX.jar`
   - Placer dans `WebContent/WEB-INF/lib/`

### Étape 3: Déployer sur Tomcat

1. **Démarrer Tomcat**:
   - Sur Windows: `startup.bat` dans le dossier bin
   - Sur Linux/Mac: `./startup.sh` dans le dossier bin

2. **Accéder à l'application**:
   ```
   http://localhost:8080/GestionRDV/
   ```

### Étape 4: Compilation des Classes Java

Si vous utilisez un IDE:
- L'IDE compilera automatiquement les classes Java

Si vous compilez manuellement:
```bash
cd GestionRDV
javac -d WebContent/WEB-INF/classes -cp "WebContent/WEB-INF/lib/*" src/**/*.java
```

## Données de Test

Des médecins et patients de test sont inclus dans le fichier SQL:

### Patients (Identifiants de test):
- Email: `mohammed.salah@email.com` / Mot de passe: `1234`
- Email: `aisha.benali@email.com` / Mot de passe: `1234`
- Email: `ibrahim.chakir@email.com` / Mot de passe: `1234`

### Médecins (Identifiants de test):
- Email: `ahmed.bouchard@clinic.com` / Mot de passe: `1234` (Cardiologie)
- Email: `fatima.nasri@derma.com` / Mot de passe: `1234` (Dermatologie)
- Email: `hassan.bennani@hospital.com` / Mot de passe: `1234` (Pneumologie)
- Email: `leila.amouri@neuro.com` / Mot de passe: `1234` (Neurologie)
- Email: `karim.elfassi@ortho.com` / Mot de passe: `1234` (Orthopédie)

## Utilisation

### Interface Patient

1. **S'inscrire ou se connecter**: Accueil → Connexion Patient
2. **Chercher un médecin**: 
   - Par nom (barre de recherche)
   - Par spécialité (filtre)
3. **Prendre un rendez-vous**:
   - Cliquer sur "Prendre RDV"
   - Sélectionner date et heure
   - Confirmer la réservation
4. **Gérer ses rendez-vous**:
   - Voir la liste des RDV
   - Annuler si nécessaire

### Interface Médecin

1. **S'inscrire ou se connecter**: Accueil → Connexion Médecin
2. **Consulter ses rendez-vous**: Tableau de bord
3. **Gérer les rendez-vous**:
   - Confirmer les RDV en attente
   - Annuler si nécessaire
4. **Voir les statistiques**:
   - Total des RDV
   - RDV confirmés
   - Top 5 médecins les plus consultés

## Configuration Optionnelle

### Activation des Emails

Pour activer l'envoi d'emails de confirmation:

1. Modifier le fichier `src/utils/EmailUtil.java`
2. Configurer votre adresse Gmail:
   ```java
   private static final String SENDER_EMAIL = "votre_email@gmail.com";
   private static final String SENDER_PASSWORD = "votre_mot_de_passe";
   ```
3. Activer "Less secure app access" dans les paramètres Google
4. Ajouter l'appel à `EmailUtil.sendEmail()` dans les DAO

## Dépannage

### Problèmes Courants

1. **Erreur de connexion à la base de données**:
   - Vérifier que MySQL est démarré
   - Vérifier les identifiants dans `DBConnection.java`
   - Vérifier que la base `gestion_rdv` existe

2. **Erreur 404 - Page non trouvée**:
   - Vérifier le chemin d'accès de l'application
   - Vérifier que Tomcat est démarré
   - Vérifier le nom de la base (doit être `GestionRDV`)

3. **Erreur de compilation Java**:
   - Vérifier que le driver MySQL est dans `WEB-INF/lib/`
   - Nettoyer et recompiler le projet

## Notes de Sécurité

**Important**: Cette application utilise des identifiants et mots de passe en texte brut pour la démonstration.

Pour la production:
- Implémenter le hachage des mots de passe (bcrypt, SHA-256)
- Valider tous les entrées utilisateur
- Implémenter HTTPS/SSL
- Ajouter des contrôles d'accès plus stricts
- Implémenter les mécanismes CSRF

## Support et Améliorations Futures

- Système de notifications en temps réel
- Intégration du calendrier
- Paiement en ligne
- Historique des consultations
- Système de notation/avis
- API REST pour applications mobiles

## Auteur
Projet développé comme démonstration d'une application de gestion de rendez-vous médicaux.

## Licence
Libre d'utilisation pour fins éducatives.
