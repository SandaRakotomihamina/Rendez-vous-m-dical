-- Créer la base de données
CREATE DATABASE IF NOT EXISTS gestion_rdv;
USE gestion_rdv;

-- Table PATIENT
CREATE TABLE IF NOT EXISTS patient (
    idpat INT AUTO_INCREMENT PRIMARY KEY,
    nom_pat VARCHAR(100) NOT NULL,
    datenais DATE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telephone VARCHAR(15),
    mdp VARCHAR(255) NOT NULL,
    date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table MEDECIN
CREATE TABLE IF NOT EXISTS medecin (
    idmed INT AUTO_INCREMENT PRIMARY KEY,
    nommed VARCHAR(100) NOT NULL,
    specialite VARCHAR(100) NOT NULL,
    taux_horaire INT NOT NULL,
    lieu VARCHAR(200) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telephone VARCHAR(15),
    mdp VARCHAR(255) NOT NULL,
    bio TEXT,
    horaire_journalier VARCHAR(50),
    jours_travail VARCHAR(255),
    date_inscription DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Table RDV (Rendez-vous)
CREATE TABLE IF NOT EXISTS rdv (
    idrdv INT AUTO_INCREMENT PRIMARY KEY,
    idpat INT NOT NULL,
    idmed INT NOT NULL,
    date_rdv DATETIME NOT NULL,
    statut ENUM('confirmé', 'annulé', 'en_attente') DEFAULT 'en_attente',
    notes TEXT,
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (idpat) REFERENCES patient(idpat) ON DELETE CASCADE,
    FOREIGN KEY (idmed) REFERENCES medecin(idmed) ON DELETE CASCADE,
    UNIQUE KEY unique_rdv (idmed, date_rdv)
);

-- Créer les index pour améliorer les performances
CREATE INDEX idx_medecin_specialite ON medecin(specialite);
CREATE INDEX idx_rdv_patient ON rdv(idpat);
CREATE INDEX idx_rdv_medecin ON rdv(idmed);
CREATE INDEX idx_rdv_date ON rdv(date_rdv);
