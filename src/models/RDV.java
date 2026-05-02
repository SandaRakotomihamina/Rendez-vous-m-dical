package models;

import java.io.Serializable;

public class RDV implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idrdv;
    private int idpat;
    private int idmed;
    private String date_rdv;
    private String statut;
    private String notes;
    private String date_creation;
    private String nom_patient;
    private String nom_medecin;
    private String specialite_medecin;

    public RDV() {}

    public RDV(int idpat, int idmed, String date_rdv) {
        this.idpat = idpat;
        this.idmed = idmed;
        this.date_rdv = date_rdv;
        this.statut = "en_attente";
    }

    public RDV(int idrdv, int idpat, int idmed, String date_rdv, String statut) {
        this.idrdv = idrdv;
        this.idpat = idpat;
        this.idmed = idmed;
        this.date_rdv = date_rdv;
        this.statut = statut;
    }

    // Getters and Setters
    public int getIdrdv() {
        return idrdv;
    }

    public void setIdrdv(int idrdv) {
        this.idrdv = idrdv;
    }

    public int getIdpat() {
        return idpat;
    }

    public void setIdpat(int idpat) {
        this.idpat = idpat;
    }

    public int getIdmed() {
        return idmed;
    }

    public void setIdmed(int idmed) {
        this.idmed = idmed;
    }

    public String getDate_rdv() {
        return date_rdv;
    }

    public void setDate_rdv(String date_rdv) {
        this.date_rdv = date_rdv;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getDate_creation() {
        return date_creation;
    }

    public void setDate_creation(String date_creation) {
        this.date_creation = date_creation;
    }

    public String getNom_patient() {
        return nom_patient;
    }

    public void setNom_patient(String nom_patient) {
        this.nom_patient = nom_patient;
    }

    public String getNom_medecin() {
        return nom_medecin;
    }

    public void setNom_medecin(String nom_medecin) {
        this.nom_medecin = nom_medecin;
    }

    public String getSpecialite_medecin() {
        return specialite_medecin;
    }

    public void setSpecialite_medecin(String specialite_medecin) {
        this.specialite_medecin = specialite_medecin;
    }

    @Override
    public String toString() {
        return "RDV{" +
                "idrdv=" + idrdv +
                ", idpat=" + idpat +
                ", idmed=" + idmed +
                ", date_rdv='" + date_rdv + '\'' +
                ", statut='" + statut + '\'' +
                '}';
    }
}
