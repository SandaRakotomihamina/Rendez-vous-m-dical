package dao;

import models.RDV;
import utils.DBConnection;
import java.sql.*;
import java.util.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class RDVDAO {

    // Ajouter un rendez-vous
    public static boolean addRDV(RDV rdv) {
        String sql = "INSERT INTO rdv (idpat, idmed, date_rdv, statut) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, rdv.getIdpat());
            ps.setInt(2, rdv.getIdmed());
            ps.setString(3, rdv.getDate_rdv());
            ps.setString(4, rdv.getStatut() != null ? rdv.getStatut() : "en_attente");
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

    // Obtenir tous les rendez-vous
    public static List<RDV> getAllRDV() {
        List<RDV> rdvs = new ArrayList<>();
        String sql = "SELECT r.*, p.nom_pat, m.nommed, m.specialite FROM rdv r " +
                     "JOIN patient p ON r.idpat = p.idpat " +
                     "JOIN medecin m ON r.idmed = m.idmed " +
                     "ORDER BY r.date_rdv DESC";
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                RDV rdv = new RDV(
                    rs.getInt("idrdv"),
                    rs.getInt("idpat"),
                    rs.getInt("idmed"),
                    rs.getString("date_rdv"),
                    rs.getString("statut")
                );
                rdv.setNom_patient(rs.getString("nom_pat"));
                rdv.setNom_medecin(rs.getString("nommed"));
                rdv.setSpecialite_medecin(rs.getString("specialite"));
                rdv.setDate_creation(rs.getString("date_creation"));
                rdvs.add(rdv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(stmt);
            DBConnection.closeConnection(conn);
        }
        return rdvs;
    }

    // Obtenir les rendez-vous d'un patient
    public static List<RDV> getRDVByPatient(int idpat) {
        List<RDV> rdvs = new ArrayList<>();
        String sql = "SELECT r.*, p.nom_pat, m.nommed, m.specialite FROM rdv r " +
                     "JOIN patient p ON r.idpat = p.idpat " +
                     "JOIN medecin m ON r.idmed = m.idmed " +
                     "WHERE r.idpat = ? " +
                     "ORDER BY r.date_rdv DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idpat);
            rs = ps.executeQuery();
            while (rs.next()) {
                RDV rdv = new RDV(
                    rs.getInt("idrdv"),
                    rs.getInt("idpat"),
                    rs.getInt("idmed"),
                    rs.getString("date_rdv"),
                    rs.getString("statut")
                );
                rdv.setNom_patient(rs.getString("nom_pat"));
                rdv.setNom_medecin(rs.getString("nommed"));
                rdv.setSpecialite_medecin(rs.getString("specialite"));
                rdv.setDate_creation(rs.getString("date_creation"));
                rdvs.add(rdv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
        return rdvs;
    }

    // Obtenir les rendez-vous d'un médecin
    public static List<RDV> getRDVByMedecin(int idmed) {
        List<RDV> rdvs = new ArrayList<>();
        String sql = "SELECT r.*, p.nom_pat, m.nommed, m.specialite FROM rdv r " +
                     "JOIN patient p ON r.idpat = p.idpat " +
                     "JOIN medecin m ON r.idmed = m.idmed " +
                     "WHERE r.idmed = ? " +
                     "ORDER BY r.date_rdv ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idmed);
            rs = ps.executeQuery();
            while (rs.next()) {
                RDV rdv = new RDV(
                    rs.getInt("idrdv"),
                    rs.getInt("idpat"),
                    rs.getInt("idmed"),
                    rs.getString("date_rdv"),
                    rs.getString("statut")
                );
                rdv.setNom_patient(rs.getString("nom_pat"));
                rdv.setNom_medecin(rs.getString("nommed"));
                rdv.setSpecialite_medecin(rs.getString("specialite"));
                rdv.setDate_creation(rs.getString("date_creation"));
                rdvs.add(rdv);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
        return rdvs;
    }

    // Obtenir un RDV par ID
    public static RDV getRDVById(int id) {
        String sql = "SELECT r.*, p.nom_pat, m.nommed, m.specialite FROM rdv r " +
                     "JOIN patient p ON r.idpat = p.idpat " +
                     "JOIN medecin m ON r.idmed = m.idmed " +
                     "WHERE r.idrdv = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                RDV rdv = new RDV(
                    rs.getInt("idrdv"),
                    rs.getInt("idpat"),
                    rs.getInt("idmed"),
                    rs.getString("date_rdv"),
                    rs.getString("statut")
                );
                rdv.setNom_patient(rs.getString("nom_pat"));
                rdv.setNom_medecin(rs.getString("nommed"));
                rdv.setSpecialite_medecin(rs.getString("specialite"));
                rdv.setDate_creation(rs.getString("date_creation"));
                rdv.setNotes(rs.getString("notes"));
                return rdv;
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

    // Obtenir les horaires disponibles d'un médecin
    public static List<String> getAvailableTimeslots(int idmed, String date) {
        List<String> available = new ArrayList<>();
        String sqlOccupied = "SELECT HOUR(date_rdv) as hour FROM rdv WHERE idmed = ? AND DATE(date_rdv) = ? AND statut != 'annulé'";
        
        Set<Integer> occupiedHours = new HashSet<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sqlOccupied);
            ps.setInt(1, idmed);
            ps.setString(2, date);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                occupiedHours.add(rs.getInt("hour"));
            }
            
            // Les horaires disponibles sont de 8h à 18h
            for (int hour = 8; hour < 18; hour++) {
                if (!occupiedHours.contains(hour)) {
                    available.add(String.format("%02d:00", hour));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.closeResultSet(rs);
            DBConnection.closeStatement(ps);
            DBConnection.closeConnection(conn);
        }
        
        return available;
    }

    // Annuler un RDV
    public static boolean cancelRDV(int id) {
        String sql = "UPDATE rdv SET statut = 'annulé' WHERE idrdv = ?";
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

    // Confirmer un RDV
    public static boolean confirmRDV(int id) {
        String sql = "UPDATE rdv SET statut = 'confirmé' WHERE idrdv = ?";
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

    // Mettre à jour un RDV
    public static boolean updateRDV(RDV rdv) {
        String sql = "UPDATE rdv SET idpat = ?, idmed = ?, date_rdv = ?, statut = ?, notes = ? WHERE idrdv = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, rdv.getIdpat());
            ps.setInt(2, rdv.getIdmed());
            ps.setString(3, rdv.getDate_rdv());
            ps.setString(4, rdv.getStatut());
            ps.setString(5, rdv.getNotes());
            ps.setInt(6, rdv.getIdrdv());
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

    // Supprimer un RDV
    public static boolean deleteRDV(int id) {
        String sql = "DELETE FROM rdv WHERE idrdv = ?";
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

    // Vérifier si un créneau est disponible
    public static boolean isTimeslotAvailable(int idmed, String dateTime) {
        String sql = "SELECT COUNT(*) FROM rdv WHERE idmed = ? AND date_rdv = ? AND statut != 'annulé'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idmed);
            ps.setString(2, dateTime);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
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
