package models;

import java.io.Serializable;

public class Patient implements Serializable {
    private static final long serialVersionUID = 1L;
    private int idpat;
    private String nom_pat;
    private String datenais;
    private String email;
    private String telephone;
    private String mdp;
    private String date_inscription;

    public Patient() {}

    public Patient(String nom_pat, String datenais, String email, String telephone, String mdp) {
        this.nom_pat = nom_pat;
        this.datenais = datenais;
        this.email = email;
        this.telephone = telephone;
        this.mdp = mdp;
    }

    public Patient(int idpat, String nom_pat, String datenais, String email, String telephone, String mdp) {
        this.idpat = idpat;
        this.nom_pat = nom_pat;
        this.datenais = datenais;
        this.email = email;
        this.telephone = telephone;
        this.mdp = mdp;
    }

    // Getters and Setters
    public int getIdpat() {
        return idpat;
    }

    public void setIdpat(int idpat) {
        this.idpat = idpat;
    }

    public String getNom_pat() {
        return nom_pat;
    }

    public void setNom_pat(String nom_pat) {
        this.nom_pat = nom_pat;
    }

    public String getDatenais() {
        return datenais;
    }

    public void setDatenais(String datenais) {
        this.datenais = datenais;
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

    public String getDate_inscription() {
        return date_inscription;
    }

    public void setDate_inscription(String date_inscription) {
        this.date_inscription = date_inscription;
    }

    @Override
    public String toString() {
        return "Patient{" +
                "idpat=" + idpat +
                ", nom_pat='" + nom_pat + '\'' +
                ", datenais='" + datenais + '\'' +
                ", email='" + email + '\'' +
                ", telephone='" + telephone + '\'' +
                '}';
    }
}
