# 📱 URLs et Navigation de l'Application

## URLs Principales

### Page d'Accueil
```
http://localhost:8080/GestionRDV/
http://localhost:8080/GestionRDV/index.jsp
```

### Connexion/Inscription
```
http://localhost:8080/GestionRDV/login-patient.jsp
http://localhost:8080/GestionRDV/login-medecin.jsp
```

### Tableaux de Bord (Après connexion)
```
http://localhost:8080/GestionRDV/patient-dashboard.jsp
http://localhost:8080/GestionRDV/medecin-dashboard.jsp
```

### Déconnexion
```
http://localhost:8080/GestionRDV/logout.jsp
```

---

## 🗺️ Flux de Navigation

### Patient
```
index.jsp
    ↓
login-patient.jsp (S'inscrire ou Se connecter)
    ↓
patient-dashboard.jsp (Tableau de bord)
    ├─ Chercher médecin
    ├─ Prendre RDV
    ├─ Consulter RDV
    └─ Annuler RDV
    ↓
logout.jsp
```

### Médecin
```
index.jsp
    ↓
login-medecin.jsp (S'inscrire ou Se connecter)
    ↓
medecin-dashboard.jsp (Tableau de bord)
    ├─ Consulter RDV
    ├─ Confirmer RDV
    ├─ Annuler RDV
    └─ Voir statistiques
    ↓
logout.jsp
```

---

## 🔐 Authentification

### Session Variables
```jsp
<!-- Patient -->
<%= session.getAttribute("patient_id") %>
<%= session.getAttribute("patient_name") %>
<%= session.getAttribute("patient_email") %>

<!-- Médecin -->
<%= session.getAttribute("medecin_id") %>
<%= session.getAttribute("medecin_name") %>
<%= session.getAttribute("medecin_email") %>
<%= session.getAttribute("medecin_specialite") %>
```

### Redirection si non authentifié
Automatique vers `login-*.jsp` si session invalide

---

## 📊 Paramètres et Actions

### Patient Dashboard
```
GET patient-dashboard.jsp
    ?action=add_rdv&idmed=X&date_rdv=YYYY-MM-DD HH:MM
    ?action=cancel_rdv&idrdv=X
    ?search=nom_medecin
    ?specialite=Cardiologue
```

### Médecin Dashboard
```
GET medecin-dashboard.jsp
    ?action=confirm_rdv&idrdv=X
    ?action=cancel_rdv&idrdv=X
```

### API Horaires
```
GET get-timeslots.jsp
    ?medecin_id=X
    &date=YYYY-MM-DD
    
Response: JSON array ["08:00", "09:00", "10:00", ...]
```

---

## 🔗 Liens Internes

### Depuis index.jsp
- `login-patient.jsp` - Connexion Patient
- `login-medecin.jsp` - Connexion Médecin

### Depuis login-patient.jsp
- `index.jsp` - Retour à l'accueil

### Depuis patient-dashboard.jsp
- `logout.jsp` - Déconnexion
- `index.jsp` (via navbar)

### Depuis medecin-dashboard.jsp
- `logout.jsp` - Déconnexion
- `index.jsp` (via navbar)

---

## 🎯 Cheminement Utilisateur Complet

### Scénario Patient
```
1. Accès: http://localhost:8080/GestionRDV/
   ↓
2. Clic "Connexion Patient"
   ↓
3. Saisie credentials (ou inscription)
   ↓
4. Redirection à patient-dashboard.jsp
   ↓
5. Recherche médecin par nom ou spécialité
   ↓
6. Sélection médecin → Clic "Prendre RDV"
   ↓
7. Modal de réservation
   ↓
8. Sélection date/heure
   ↓
9. Soumission → RDVDAO.addRDV()
   ↓
10. Message de confirmation
   ↓
11. RDV visible dans la liste
   ↓
12. Clic "Déconnexion" → logout.jsp
```

### Scénario Médecin
```
1. Accès: http://localhost:8080/GestionRDV/
   ↓
2. Clic "Connexion Médecin"
   ↓
3. Saisie credentials (ou inscription)
   ↓
4. Redirection à medecin-dashboard.jsp
   ↓
5. Vue du tableau de bord avec statistiques
   ↓
6. Liste des RDV en attente
   ↓
7. Actions: Confirmer ou Annuler
   ↓
8. Vue du Top 5 médecins
   ↓
9. Clic "Déconnexion" → logout.jsp
```

---

## 📡 Appels DAO

### PatientDAO
```java
// Lecture
PatientDAO.getPatientById(id)
PatientDAO.getAllPatients()
PatientDAO.authenticatePatient(email, mdp)

// Écriture
PatientDAO.addPatient(patient)
PatientDAO.updatePatient(patient)
PatientDAO.deletePatient(id)

// Vérification
PatientDAO.emailExists(email)
```

### MedecinDAO
```java
// Lecture
MedecinDAO.getMedecinById(id)
MedecinDAO.getAllMedecins()
MedecinDAO.authenticateMedecin(email, mdp)
MedecinDAO.searchMedecinByName(nom)
MedecinDAO.getMedecinsBySpecialite(specialite)
MedecinDAO.getTopMedecins()
MedecinDAO.getAllSpecialites()

// Écriture
MedecinDAO.addMedecin(medecin)
MedecinDAO.updateMedecin(medecin)
MedecinDAO.deleteMedecin(id)

// Vérification
MedecinDAO.emailExists(email)
```

### RDVDAO
```java
// Lecture
RDVDAO.getAllRDV()
RDVDAO.getRDVById(id)
RDVDAO.getRDVByPatient(idpat)
RDVDAO.getRDVByMedecin(idmed)
RDVDAO.getAvailableTimeslots(idmed, date)

// Écriture
RDVDAO.addRDV(rdv)
RDVDAO.updateRDV(rdv)
RDVDAO.deleteRDV(id)

// Actions
RDVDAO.confirmRDV(id)
RDVDAO.cancelRDV(id)

// Vérification
RDVDAO.isTimeslotAvailable(idmed, dateTime)
```

---

## 🔄 Flux de Requêtes HTTP

### Inscription Patient
```
POST login-patient.jsp
  action=register
  nom_pat=...
  datenais=...
  email=...
  telephone=...
  mdp=...
  
→ PatientDAO.addPatient()
→ Message succès/erreur
```

### Connexion Patient
```
POST login-patient.jsp
  action=login
  email=...
  mdp=...
  
→ PatientDAO.authenticatePatient()
→ Créer session
→ Redirection patient-dashboard.jsp
```

### Prendre RDV
```
POST patient-dashboard.jsp
  action=add_rdv
  idmed=X
  date_rdv=YYYY-MM-DD HH:MM
  
→ RDVDAO.isTimeslotAvailable()
→ RDVDAO.addRDV()
→ Message succès/erreur
```

### Annuler RDV
```
GET patient-dashboard.jsp (ou medecin-dashboard.jsp)
  action=cancel_rdv
  idrdv=X
  
→ RDVDAO.cancelRDV()
→ Message de confirmation
```

### Confirmer RDV
```
GET medecin-dashboard.jsp
  action=confirm_rdv
  idrdv=X
  
→ RDVDAO.confirmRDV()
→ Message de confirmation
```

---

## 📊 Variables de Session

### Session Patient
```java
session.getAttribute("patient_id");      // Integer
session.getAttribute("patient_name");    // String
session.getAttribute("patient_email");   // String
```

### Session Médecin
```java
session.getAttribute("medecin_id");      // Integer
session.getAttribute("medecin_name");    // String
session.getAttribute("medecin_email");   // String
session.getAttribute("medecin_specialite"); // String
```

### Invalidation
```java
session.invalidate();  // À l'appel de logout.jsp
```

---

## 🎨 Elements de l'Interface

### Barres de Navigation
- **Patient**: Bienvenue + Déconnexion
- **Médecin**: Dr. Nom + Déconnexion
- **Accueil**: Connexion Patient / Connexion Médecin

### Formulaires
- Inscription/Connexion (2 formulaires parallèles)
- Recherche (Nom + Spécialité)
- Modal de réservation

### Tableaux
- Liste des RDV
- Liste des médecins
- Top 5 médecins

### Cartes
- Statistiques (3 cartes)
- Informations médecin
- Détails RDV

---

## 🚨 Gestion des Erreurs

### Messages d'Erreur
```
❌ "Email ou mot de passe incorrect"
❌ "Cet email est déjà utilisé"
❌ "Erreur lors de l'inscription"
❌ "Créneau non disponible"
❌ "Page non trouvée"
```

### Redirection Automatique
```java
if (session.getAttribute("patient_id") == null) {
    response.sendRedirect("login-patient.jsp");
}
```

---

## ✨ Bonnes Pratiques Respectées

✅ Séparation des préoccupations (MVC)
✅ Injection d'objets dans JSP via DAO
✅ Gestion de sessions sécurisée
✅ Validation des entrées
✅ Fermeture des ressources (DB)
✅ Transactions cohérentes
✅ Messages utilisateur clairs
✅ Redirection appropriée

---

**Navigation facile et intuitive! 🎯**
