package dao;

import models.Patient;
import utils.DBConnection;
import java.sql.*;
import java.util.*;

public class PatientDAO {

    // Ajouter un patient
    public static boolean addPatient(Patient patient) {
        String sql = "INSERT INTO patient (nom_pat, datenais, email, telephone, mdp) VALUES (?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, patient.getNom_pat());
            ps.setString(2, patient.getDatenais());
            ps.setString(3, patient.getEmail());
            ps.setString(4, patient.getTelephone());
            ps.setString(5, patient.getMdp());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
    }

    // Obtenir tous les patients
    public static List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM patient ORDER BY date_inscription DESC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Patient patient = new Patient(
                    rs.getInt("idpat"),
                    rs.getString("nom_pat"),
                    rs.getString("datenais"),
                    rs.getString("email"),
                    rs.getString("telephone"),
                    rs.getString("mdp")
                );
                patient.setDate_inscription(rs.getString("date_inscription"));
                patients.add(patient);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(stmt);
            DBConnection.closeConnection(conn);
        }
        return patients;
    }

    // Obtenir un patient par ID
    public static Patient getPatientById(int id) {
        String sql = "SELECT * FROM patient WHERE idpat = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Patient patient = new Patient(
                    rs.getInt("idpat"),
                    rs.getString("nom_pat"),
                    rs.getString("datenais"),
                    rs.getString("email"),
                    rs.getString("telephone"),
                    rs.getString("mdp")
                );
                patient.setDate_inscription(rs.getString("date_inscription"));
                return patient;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    // Authentifier un patient
    public static Patient authenticatePatient(String email, String mdp) {
        String sql = "SELECT * FROM patient WHERE email = ? AND mdp = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, mdp);
            rs = ps.executeQuery();
            if (rs.next()) {
                Patient patient = new Patient(
                    rs.getInt("idpat"),
                    rs.getString("nom_pat"),
                    rs.getString("datenais"),
                    rs.getString("email"),
                    rs.getString("telephone"),
                    rs.getString("mdp")
                );
                return patient;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
        return null;
    }

    // Mettre à jour un patient
    public static boolean updatePatient(Patient patient, boolean updatePassword) {
        String sql;
        if (updatePassword) {
            sql = "UPDATE patient SET nom_pat = ?, datenais = ?, email = ?, telephone = ?, mdp = ? WHERE idpat = ?";
        } else {
            sql = "UPDATE patient SET nom_pat = ?, datenais = ?, email = ?, telephone = ? WHERE idpat = ?";
        }
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, patient.getNom_pat());
            ps.setString(2, patient.getDatenais());
            ps.setString(3, patient.getEmail());
            ps.setString(4, patient.getTelephone());
            if (updatePassword) {
                ps.setString(5, patient.getMdp());
                ps.setInt(6, patient.getIdpat());
            } else {
                ps.setInt(5, patient.getIdpat());
            }
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
    }

    // Supprimer un patient
    public static boolean deletePatient(int id) {
        String sql = "DELETE FROM patient WHERE idpat = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
    }

    // Vérifier si l'email existe
    public static boolean emailExists(String email) {
        String sql = "SELECT COUNT(*) FROM patient WHERE email = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
        return false;
    }
}
