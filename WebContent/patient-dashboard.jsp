<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.PatientDAO, dao.MedecinDAO, dao.RDVDAO" %>
<%@ page import="models.Patient, models.Medecin, models.RDV" %>
<%@ page import="utils.EmailUtil" %>
<%@ page import="java.util.List" %>

<%
    if (session.getAttribute("patient_id") == null) {
        response.sendRedirect("login-patient.jsp");
        return;
    }

    int patient_id = (Integer) session.getAttribute("patient_id");
    String patient_name = (String) session.getAttribute("patient_name");
    
    String action = request.getParameter("action");
    String message = "";
    String messageType = "";

    // Ajouter un rendez-vous
    if ("add_rdv".equals(action)) {
        int idmed = Integer.parseInt(request.getParameter("idmed"));
        String date_rdv = request.getParameter("date_rdv");
        
        if (RDVDAO.isTimeslotAvailable(idmed, date_rdv)) {
            RDV rdv = new RDV(patient_id, idmed, date_rdv);
            if (RDVDAO.addRDV(rdv)) {
                message = "Rendez-vous réservé avec succès!";
                messageType = "success";
                
                // Envoyer email au médecin
                Medecin med = MedecinDAO.getMedecinById(idmed);
                String subject = "Nouveau rendez-vous réservé";
                String body = "Cher Dr. " + med.getNommed() + ",\n\nUn nouveau rendez-vous a été réservé par " + patient_name + " pour le " + date_rdv + ".\n\nCordialement,\nSystème de Gestion des RDV";
                EmailUtil.sendEmail(med.getEmail(), subject, body);
            } else {
                message = "Erreur lors de la réservation";
                messageType = "danger";
            }
        } else {
            message = "Désolé, un autre rendez-vous est déjà fixé à cette date";
            messageType = "warning";
        }
    }

    // Annuler un rendez-vous
    if ("yes".equals(request.getParameter("cancel_action"))) {
        int idrdv = Integer.parseInt(request.getParameter("idrdv"));
        if (RDVDAO.cancelRDV(idrdv)) {
            message = "Rendez-vous annulé";
            messageType = "info";
            
            // Envoyer email au médecin
            RDV rdv = RDVDAO.getRDVById(idrdv);
            Medecin med = MedecinDAO.getMedecinById(rdv.getIdmed());
            String subject = "Rendez-vous annulé";
            String body = "Cher Dr. " + med.getNommed() + ",\n\nLe rendez-vous prévu le " + rdv.getDate_rdv() + " avec " + patient_name + " a été annulé.\n\nCordialement,\nSystème de Gestion des RDV";
            EmailUtil.sendEmail(med.getEmail(), subject, body);
        }
    }

    List<RDV> rdvs = RDVDAO.getRDVByPatient(patient_id);
    List<Medecin> medecins = MedecinDAO.getAllMedecins();
    List<String> specialites = MedecinDAO.getAllSpecialites();
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de Bord Patient</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
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
                            <a href="patient-about.jsp" class="text-light text-decoration-none">Bienvenue, <%= patient_name %></a>
                        </span>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout.jsp">Déconnexion</a>
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
            <!-- Chercher un médecin -->
            <div class="col-md-12 mb-4">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Chercher un Médecin</h5>
                    </div>
                    <div class="card-body">
                        <form method="GET" class="row g-3">
                            <div class="col-md-6">
                                <input type="text" class="form-control" name="search" placeholder="Chercher par nom...">
                            </div>
                            <div class="col-md-4">
                                <select class="form-select" name="specialite">
                                    <option value="">Toutes les spécialités</option>
                                    <% for (String spec : specialites) { %>
                                        <option value="<%= spec %>"><%= spec %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100">Chercher</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Liste des médecins -->
            <div class="col-md-12 mb-4">
                <div class="card shadow">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Médecins Disponibles</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <% 
                                String search = request.getParameter("search");
                                String specialiteFilter = request.getParameter("specialite");
                                
                                List<Medecin> filteredMedecins = medecins;
                                
                                if (search != null && !search.isEmpty()) {
                                    filteredMedecins = MedecinDAO.searchMedecinByName(search);
                                }
                                
                                if (specialiteFilter != null && !specialiteFilter.isEmpty()) {
                                    filteredMedecins = MedecinDAO.getMedecinsBySpecialite(specialiteFilter);
                                }
                                
                                for (Medecin med : filteredMedecins) {
                            %>
                            <div class="col-md-6 mb-3">
                                <div class="card border-primary">
                                    <div class="card-body">
                                        <h5 class="card-title"><%= med.getNommed() %></h5>
                                        <p class="card-text">
                                            <strong>Spécialité:</strong> <%= med.getSpecialite() %><br>
                                            <strong>Taux horaire:</strong> <%= med.getTaux_horaire() %> DH<br>
                                            <strong>Lieu:</strong> <%= med.getLieu() %><br>
                                            <strong>Bio:</strong> <%= med.getBio() != null ? med.getBio() : "N/A" %>
                                        </p>
                                        <button class="btn btn-sm btn-success" data-bs-toggle="modal" 
                                            data-bs-target="#rdvModal" 
                                            onclick="setMedecinId('<%= med.getIdmed() %>', '<%= med.getNommed() %>')">
                                            Prendre RDV
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Mes rendez-vous -->
            <div class="col-md-12">
                <div class="card shadow">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Mes Rendez-vous</h5>
                    </div>
                    <div class="card-body">
                        <% if (rdvs.isEmpty()) { %>
                            <p class="text-muted">Vous n'avez pas encore de rendez-vous</p>
                        <% } else { %>
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Médecin</th>
                                        <th>Spécialité</th>
                                        <th>Date/Heure</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (RDV rdv : rdvs) { %>
                                    <tr>
                                        <td><%= rdv.getNom_medecin() %></td>
                                        <td><%= rdv.getSpecialite_medecin() %></td>
                                        <td><%= rdv.getDate_rdv() %></td>
                                        <td>
                                            <% if ("confirmé".equals(rdv.getStatut())) { %>
                                                <span class="badge bg-success">Confirmé</span>
                                            <% } else if ("annulé".equals(rdv.getStatut())) { %>
                                                <span class="badge bg-danger">Annulé</span>
                                            <% } else { %>
                                                <span class="badge bg-warning">En attente</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <% if (!"annulé".equals(rdv.getStatut())) { %>
                                                <form method="GET" style="display:inline;">
                                                    <input type="hidden" name="cancel_action" value="yes">
                                                    <input type="hidden" name="idrdv" value="<%= rdv.getIdrdv() %>">
                                                    <button type="submit" class="btn btn-sm btn-danger" 
                                                        onclick="return confirm('Êtes-vous sûr?')">Annuler</button>
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
        </div>
    </div>

    <!-- Modal de réservation -->
    <div class="modal fade" id="rdvModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Prendre Rendez-vous</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="POST">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="add_rdv">
                        <input type="hidden" name="idmed" id="selectedMedecinId">
                        <p>Médecin: <strong id="selectedMedecinName"></strong></p>
                        <div class="mb-3">
                            <label for="date_rdv" class="form-label">Date et Heure</label>
                            <input type="datetime-local" class="form-control" id="date_rdv" name="date_rdv" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                        <button type="submit" class="btn btn-primary">Réserver</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
    <script>
        function setMedecinId(id, name) {
            document.getElementById('selectedMedecinId').value = id;
            document.getElementById('selectedMedecinName').textContent = name;
        }
    </script>
</body>
</html>
