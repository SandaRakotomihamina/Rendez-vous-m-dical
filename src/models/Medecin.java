package models;

import java.io.Serializable;

public class Medecin implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idmed;
    private String nommed;
    private String specialite;
    private int taux_horaire;
    private String lieu;
    private String email;
    private String telephone;
    private String mdp;
    private String bio;
    private String date_inscription;
    private int nombre_consultations;

    public Medecin() {}

    public Medecin(String nommed, String specialite, int taux_horaire, String lieu, String email, String telephone, String mdp) {
        this.nommed = nommed;
        this.specialite = specialite;
        this.taux_horaire = taux_horaire;
        this.lieu = lieu;
        this.email = email;
        this.telephone = telephone;
        this.mdp = mdp;
    }

    public Medecin(int idmed, String nommed, String specialite, int taux_horaire, String lieu, String email, String telephone, String bio) {
        this.idmed = idmed;
        this.nommed = nommed;
        this.specialite = specialite;
        this.taux_horaire = taux_horaire;
        this.lieu = lieu;
        this.email = email;
        this.telephone = telephone;
        this.bio = bio;
    }

    // Getters and Setters
    public int getIdmed() {
        return idmed;
    }

    public void setIdmed(int idmed) {
        this.idmed = idmed;
    }

    public String getNommed() {
        return nommed;
    }

    public void setNommed(String nommed) {
        this.nommed = nommed;
    }

    public String getSpecialite() {
        return specialite;
    }

    public void setSpecialite(String specialite) {
        this.specialite = specialite;
    }

    public int getTaux_horaire() {
        return taux_horaire;
    }

    public void setTaux_horaire(int taux_horaire) {
        this.taux_horaire = taux_horaire;
    }

    public String getLieu() {
        return lieu;
    }

    public void setLieu(String lieu) {
        this.lieu = lieu;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getMdp() {
        return mdp;
    }

    public void setMdp(String mdp) {
        this.mdp = mdp;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getDate_inscription() {
        return date_inscription;
    }

    public void setDate_inscription(String date_inscription) {
        this.date_inscription = date_inscription;
    }

    public int getNombre_consultations() {
        return nombre_consultations;
    }

    public void setNombre_consultations(int nombre_consultations) {
        this.nombre_consultations = nombre_consultations;
    }

    @Override
    public String toString() {
        return "Medecin{" +
                "idmed=" + idmed +
                ", nommed='" + nommed + '\'' +
                ", specialite='" + specialite + '\'' +
                ", taux_horaire=" + taux_horaire +
                ", lieu='" + lieu + '\'' +
                '}';
    }
}
