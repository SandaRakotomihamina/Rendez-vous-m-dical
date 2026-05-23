<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.RDVDAO, dao.MedecinDAO, dao.PatientDAO" %>
<%@ page import="models.RDV, models.Medecin, models.Patient" %>
<%@ page import="utils.EmailUtil" %>
<%@ page import="java.util.List" %>

<%
    if (session.getAttribute("medecin_id") == null) {
        response.sendRedirect("login-medecin.jsp");
        return;
    }

    int medecin_id = (Integer) session.getAttribute("medecin_id");
    String medecin_name = (String) session.getAttribute("medecin_name");
    
    String action = request.getParameter("action");
    String message = "";
    String messageType = "";

    // Confirmer un rendez-vous
    if ("confirm_rdv".equals(action)) {
        int idrdv = Integer.parseInt(request.getParameter("idrdv"));
        if (RDVDAO.confirmRDV(idrdv)) {
            message = "Rendez-vous confirmé";
            messageType = "success";
            
            // Envoyer email au patient
            RDV rdv = RDVDAO.getRDVById(idrdv);
            Patient pat = PatientDAO.getPatientById(rdv.getIdpat());
            String subject = "Rendez-vous confirmé";
            String body = "Cher " + pat.getNom_pat() + ",\n\nVotre rendez-vous avec Dr. " + medecin_name + " prévu le " + rdv.getDate_rdv() + " a été confirmé.\n\nCordialement,\nDr. " + medecin_name;
            EmailUtil.sendEmail(pat.getEmail(), subject, body);
        }
    }

    // Annuler un rendez-vous
    if ("cancel_rdv".equals(action)) {
        int idrdv = Integer.parseInt(request.getParameter("idrdv"));
        if (RDVDAO.cancelRDV(idrdv)) {
            message = "Rendez-vous annulé";
            messageType = "info";
            
            // Envoyer email au patient
            RDV rdv = RDVDAO.getRDVById(idrdv);
            Patient pat = PatientDAO.getPatientById(rdv.getIdpat());
            String subject = "Rendez-vous annulé";
            String body = "Cher " + pat.getNom_pat() + ",\n\nVotre rendez-vous avec Dr. " + medecin_name + " prévu le " + rdv.getDate_rdv() + " a été annulé.\n\nCordialement,\nDr. " + medecin_name;
            EmailUtil.sendEmail(pat.getEmail(), subject, body);
        }
    }

    // Supprimer un rendez-vous annulé
    if ("delete_rdv".equals(action)) {
        int idrdv = Integer.parseInt(request.getParameter("idrdv"));
        if (RDVDAO.deleteRDV(idrdv)) {
            message = "Rendez-vous supprimé";
            messageType = "info";
        }
    }

    List<RDV> rdvs = RDVDAO.getRDVByMedecin(medecin_id);
    List<Medecin> topMedecins = MedecinDAO.getTopMedecins();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Médecin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-hospital"></i> Rendez-vous Médical
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item" style="padding-top: 0.5rem;">
                        <span class="navbar-text text-light me-3">
                            <a href="medecin-about.jsp" class="text-light text-decoration-none">Dr. <%= medecin_name %></a>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#" onclick="return confirmLogout()">Déconnexion</a>
                    </li>   
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                <%= message %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row">
            <!-- Statistiques -->
            <div class="col-md-4 mb-3">
                <div class="card text-center bg-primary text-white">
                    <div class="card-body">
                        <h5 class="card-title">Total RDV</h5>
                        <h3><%= rdvs.size() %></h3>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card text-center bg-success text-white">
                    <div class="card-body">
                        <h5 class="card-title">RDV Confirmés</h5>
                        <h3>
                            <% int confirmed = 0;
                            for (RDV rdv : rdvs) {
                                if ("confirmé".equals(rdv.getStatut())) confirmed++;
                            } %>
                            <%= confirmed %>
                        </h3>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card text-center bg-warning text-white">
                    <div class="card-body">
                        <h5 class="card-title">En Attente</h5>
                        <h3>
                            <% int pending = 0;
                            for (RDV rdv : rdvs) {
                                if ("en_attente".equals(rdv.getStatut())) pending++;
                            } %>
                            <%= pending %>
                        </h3>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-3">
            <!-- Rendez-vous à venir -->
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Mes Rendez-vous</h5>
                    </div>
                    <div class="card-body">
                        <% if (rdvs.isEmpty()) { %>
                            <p class="text-muted">Aucun rendez-vous pour le moment</p>
                        <% } else { %>
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>Patient</th>
                                        <th>Date/Heure</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (RDV rdv : rdvs) { %>
                                    <tr>
                                        <td><%= rdv.getNom_patient() %></td>
                                        <td><%= rdv.getDate_rdv() %></td>
                                        <td>
                                            <% if ("confirmé".equals(rdv.getStatut())) { %>
                                                <span class="badge bg-success">Confirmé</span>
                                            <% } else if ("annulé".equals(rdv.getStatut())) { %>
                                                <span class="badge bg-danger">Annulé</span>
                                            <% } else { %>
                                                <span class="badge bg-warning text-dark">En attente</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if ("en_attente".equals(rdv.getStatut())) { %>
                                                <form method="GET" style="display:inline;" data-confirm="Êtes-vous sûr de vouloir confirmer ce rendez-vous ?">
                                                    <input type="hidden" name="action" value="confirm_rdv">
                                                    <input type="hidden" name="idrdv" value="<%= rdv.getIdrdv() %>">
                                                    <button type="submit" class="btn btn-sm btn-success">Confirmer</button>
                                                </form>
                                            <% } %>
                                            <% if (!"annulé".equals(rdv.getStatut())) { %>
                                                <form method="GET" style="display:inline;" data-confirm="Êtes-vous sûr de vouloir annuler ce rendez-vous ?">
                                                    <input type="hidden" name="action" value="cancel_rdv">
                                                    <input type="hidden" name="idrdv" value="<%= rdv.getIdrdv() %>">
                                                    <button type="submit" class="btn btn-sm btn-danger">Annuler</button>
                                                </form>
                                            <% } else { %>
                                                <form method="GET" style="display:inline;" data-confirm="Êtes-vous sûr de vouloir supprimer ce rendez-vous annulé ?">
                                                    <input type="hidden" name="action" value="delete_rdv">
                                                    <input type="hidden" name="idrdv" value="<%= rdv.getIdrdv() %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-danger">Supprimer</button>
                                                </form>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Top médecins les plus consultés -->
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Top 5 Médecins</h5>
                    </div>
                    <div class="card-body">
                        <% if (topMedecins.isEmpty()) { %>
                            <p class="text-muted">Pas de données disponibles</p>
                        <% } else { %>
                            <div class="list-group">
                                <% for (Medecin med : topMedecins) { %>
                                <div class="list-group-item">
                                    <h6 class="mb-1"><%= med.getNommed() %></h6>
                                    <p class="mb-1 small"><%= med.getSpecialite() %></p>
                                    <span class="badge bg-primary"><%= med.getNombre_consultations() %> consultations</span>
                                </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/script.js"></script>
    <script>
        function confirmLogout() {
            if (confirm('Êtes-vous sûr de vouloir vous déconnecter?')) {
                window.location.href = 'logout.jsp';
            }
            return false;
        }
    </script>
</body>
</html>
