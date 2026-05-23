package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import models.Medecin;
import models.RDV;
import utils.DBConnection;

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

    private static boolean isWorkday(Medecin medecin, LocalDateTime dateTime) {
        String jours = medecin.getJours_travail();
        if (jours == null || jours.trim().isEmpty()) {
            return true;
        }
        DayOfWeek day = dateTime.getDayOfWeek();
        String expected = day.toString().toLowerCase();
        String[] tokens = jours.toLowerCase().split("[,;\\s]+");
        for (String token : tokens) {
            if (token.isEmpty()) continue;
            String normalized;
            switch (token) {
                case "lundi": case "lun": normalized = "monday"; break;
                case "mardi": case "mar": normalized = "tuesday"; break;
                case "mercredi": case "mer": normalized = "wednesday"; break;
                case "jeudi": case "jeu": normalized = "thursday"; break;
                case "vendredi": case "ven": normalized = "friday"; break;
                case "samedi": case "sam": normalized = "saturday"; break;
                case "dimanche": case "dim": normalized = "sunday"; break;
                default: normalized = token;
            }
            if (normalized.equals(expected) || normalized.startsWith(expected.substring(0, 3))) {
                return true;
            }
        }
        return false;
    }

    private static boolean isWithinHours(Medecin medecin, LocalDateTime dateTime) {
        String horaire = medecin.getHoraire_journalier();
        if (horaire == null || horaire.trim().isEmpty()) {
            return true;
        }
        String[] parts = horaire.split("\\s*-\\s*");
        if (parts.length < 2) {
            return true;
        }
        try {
            LocalTime start = LocalTime.parse(parts[0].trim());
            LocalTime end = LocalTime.parse(parts[1].trim());
            LocalTime target = dateTime.toLocalTime();
            return !target.isBefore(start) && target.isBefore(end);
        } catch (Exception e) {
            return true;
        }
    }

    public static String getTimeslotAvailabilityMessage(int idmed, String dateTime) {
        LocalDateTime selected;
        try {
            selected = LocalDateTime.parse(dateTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
        } catch (Exception e) {
            return "Le format de date/heure est invalide.";
        }

        if (selected.isBefore(LocalDateTime.now())) {
            return "La date et l'heure sélectionnées sont déjà passées.";
        }

        Medecin medecin = MedecinDAO.getMedecinById(idmed);
        if (medecin == null) {
            return "Médecin introuvable.";
        }

        if (!isWorkday(medecin, selected)) {
            return "Le médecin n'est pas disponible ce jour. Veuillez choisir un autre jour de la semaine.";
        }

        if (!isWithinHours(medecin, selected)) {
            return "L'heure choisie ne correspond pas à l'horaire quotidien du médecin. Veuillez sélectionner une heure dans son créneau de travail.";
        }

        String sql = "SELECT COUNT(*) FROM rdv WHERE idmed = ? AND date_rdv = ? AND statut != 'annulé'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idmed);
            ps.setString(2, dateTime);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return "Ce créneau est déjà réservé pour ce médecin.";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return "Erreur lors de la vérification de la disponibilité.";
        }

        return "OK";
    }

    public static boolean isTimeslotAvailable(int idmed, String dateTime) {
        return "OK".equals(getTimeslotAvailabilityMessage(idmed, dateTime));
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
}
