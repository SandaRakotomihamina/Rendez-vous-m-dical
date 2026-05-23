package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import models.Medecin;
import utils.DBConnection;

public class MedecinDAO {

    private static Medecin buildMedecin(ResultSet rs) throws SQLException {
        Medecin medecin = new Medecin();
        medecin.setIdmed(rs.getInt("idmed"));
        medecin.setNommed(rs.getString("nommed"));
        medecin.setSpecialite(rs.getString("specialite"));
        medecin.setTaux_horaire(rs.getInt("taux_horaire"));
        medecin.setLieu(rs.getString("lieu"));
        medecin.setEmail(rs.getString("email"));
        medecin.setTelephone(rs.getString("telephone"));
        medecin.setBio(rs.getString("bio"));
        medecin.setHoraire_journalier(rs.getString("horaire_journalier"));
        medecin.setJours_travail(rs.getString("jours_travail"));
        return medecin;
    }

    // Ajouter un médecin
    public static boolean addMedecin(Medecin medecin) {
        String sql = "INSERT INTO medecin (nommed, specialite, taux_horaire, lieu, email, telephone, mdp, bio, horaire_journalier, jours_travail) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, medecin.getNommed());
            ps.setString(2, medecin.getSpecialite());
            ps.setInt(3, medecin.getTaux_horaire());
            ps.setString(4, medecin.getLieu());
            ps.setString(5, medecin.getEmail());
            ps.setString(6, medecin.getTelephone());
            ps.setString(7, medecin.getMdp());
            ps.setString(8, medecin.getBio());
            ps.setString(9, medecin.getHoraire_journalier());
            ps.setString(10, medecin.getJours_travail());
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

    // Obtenir tous les médecins
    public static List<Medecin> getAllMedecins() {
        List<Medecin> medecins = new ArrayList<>();
        String sql = "SELECT * FROM medecin ORDER BY nommed ASC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Medecin medecin = buildMedecin(rs);
                medecins.add(medecin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(stmt);
            DBConnection.closeConnection(conn);
        }
        return medecins;
    }

    // Obtenir un médecin par ID
    public static Medecin getMedecinById(int id) {
        String sql = "SELECT * FROM medecin WHERE idmed = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return buildMedecin(rs);
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

    // Authentifier un médecin
    public static Medecin authenticateMedecin(String email, String mdp) {
        String sql = "SELECT * FROM medecin WHERE email = ? AND mdp = ?";
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
                return buildMedecin(rs);
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

    // Rechercher médecins par spécialité
    public static List<Medecin> getMedecinsBySpecialite(String specialite) {
        List<Medecin> medecins = new ArrayList<>();
        String sql = "SELECT * FROM medecin WHERE specialite = ? ORDER BY nommed ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, specialite);
            rs = ps.executeQuery();
            while (rs.next()) {
                Medecin medecin = buildMedecin(rs);
                medecins.add(medecin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
        return medecins;
    }

    // Rechercher médecins par nom (LIKE)
    public static List<Medecin> searchMedecinByName(String nom) {
        List<Medecin> medecins = new ArrayList<>();
        String sql = "SELECT * FROM medecin WHERE nommed LIKE ? ORDER BY nommed ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + nom + "%");
            rs = ps.executeQuery();
            while (rs.next()) {
                Medecin medecin = buildMedecin(rs);
                medecins.add(medecin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
        return medecins;
    }

    // Obtenir les 5 médecins les plus consultés
    public static List<Medecin> getTopMedecins() {
        List<Medecin> medecins = new ArrayList<>();
        String sql = "SELECT m.*, COUNT(r.idrdv) as nombre_consultations FROM medecin m " +
                     "LEFT JOIN rdv r ON m.idmed = r.idmed " +
                     "GROUP BY m.idmed " +
                     "ORDER BY nombre_consultations DESC " +
                     "LIMIT 5";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                Medecin medecin = buildMedecin(rs);
                medecin.setNombre_consultations(rs.getInt("nombre_consultations"));
                medecins.add(medecin);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(stmt);
            DBConnection.closeConnection(conn);
        }
        return medecins;
    }

    // Mettre à jour un médecin
    public static boolean updateMedecin(Medecin medecin, boolean updatePassword) {
        String sql;
        if (updatePassword) {
            sql = "UPDATE medecin SET nommed = ?, specialite = ?, taux_horaire = ?, lieu = ?, email = ?, telephone = ?, mdp = ?, bio = ?, horaire_journalier = ?, jours_travail = ? WHERE idmed = ?";
        } else {
            sql = "UPDATE medecin SET nommed = ?, specialite = ?, taux_horaire = ?, lieu = ?, email = ?, telephone = ?, bio = ?, horaire_journalier = ?, jours_travail = ? WHERE idmed = ?";
        }
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, medecin.getNommed());
            ps.setString(2, medecin.getSpecialite());
            ps.setInt(3, medecin.getTaux_horaire());
            ps.setString(4, medecin.getLieu());
            ps.setString(5, medecin.getEmail());
            ps.setString(6, medecin.getTelephone());
            if (updatePassword) {
                ps.setString(7, medecin.getMdp());
                ps.setString(8, medecin.getBio());
                ps.setString(9, medecin.getHoraire_journalier());
                ps.setString(10, medecin.getJours_travail());
                ps.setInt(11, medecin.getIdmed());
            } else {
                ps.setString(7, medecin.getBio());
                ps.setString(8, medecin.getHoraire_journalier());
                ps.setString(9, medecin.getJours_travail());
                ps.setInt(10, medecin.getIdmed());
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

    // Supprimer un médecin
    public static boolean deleteMedecin(int id) {
        String sql = "DELETE FROM medecin WHERE idmed = ?";
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
        String sql = "SELECT COUNT(*) FROM medecin WHERE email = ?";
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

    // Obtenir toutes les spécialités distinctes
    public static List<String> getAllSpecialites() {
        List<String> specialites = new ArrayList<>();
        String sql = "SELECT DISTINCT specialite FROM medecin ORDER BY specialite ASC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                specialites.add(rs.getString("specialite"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(stmt);
            DBConnection.closeConnection(conn);
        }
        return specialites;
    }
}
