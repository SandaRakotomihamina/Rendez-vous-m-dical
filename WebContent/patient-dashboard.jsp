<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.PatientDAO, dao.MedecinDAO, dao.RDVDAO" %>
<%@ page import="models.Patient, models.Medecin, models.RDV" %>
<%@ page import="utils.EmailUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

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
    List<Medecin> topMedecins = MedecinDAO.getTopMedecins();
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

        <div class="row dashboard-layout gx-4">
            <div class="col-lg-4 dashboard-column-left">
                <div class="card shadow dashboard-panel mb-4">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Top 5 Médecins</h5>
                    </div>
                    <div class="card-body dashboard-panel-content">
                        <% if (topMedecins == null || topMedecins.isEmpty()) { %>
                            <p class="text-muted">Aucun médecin actif disponible.</p>
                        <% } else { %>
                            <div class="list-group">
                                <% for (Medecin med : topMedecins) { %>
                                <div class="list-group-item">
                                    <h6 class="mb-1"><%= med.getNommed() %></h6>
                                    <p class="mb-1 small"><strong>Spécialité:</strong> <%= med.getSpecialite() %></p>
                                    <span class="badge bg-primary"><%= med.getNombre_consultations() %> consultations</span>
                                </div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>

            <div class="col-lg-8 dashboard-column-right">
                <div class="card shadow dashboard-panel mb-4">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">Mes Rendez-vous</h5>
                    </div>
                    <div class="card-body dashboard-panel-content">
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

                <div class="card shadow dashboard-panel mb-4 available-doctors-panel">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Médecins Disponibles</h5>
                    </div>
                    <div class="card-body dashboard-panel-content">
                        <form method="GET" class="row g-3 mb-4">
                            <div class="col-md-6">
                                <input type="text" class="form-control" name="search" placeholder="Chercher par nom..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                            </div>
                            <div class="col-md-4">
                                <select class="form-select" name="specialite">
                                    <option value="" <%= (request.getParameter("specialite") == null || request.getParameter("specialite").isEmpty()) ? "selected" : "" %>>Toutes les spécialités</option>
                                    <% for (String spec : specialites) { %>
                                        <option value="<%= spec %>" <%= spec.equals(request.getParameter("specialite")) ? "selected" : "" %>><%= spec %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="submit" class="btn btn-primary w-100">Chercher</button>
                            </div>
                        </form>
                        <div class="row">
                            <% 
                                String search = request.getParameter("search");
                                String specialiteFilter = request.getParameter("specialite");
                                
                                List<Medecin> filteredMedecins = new ArrayList<>();
                                
                                if ((search == null || search.trim().isEmpty()) && (specialiteFilter == null || specialiteFilter.isEmpty())) {
                                    filteredMedecins = medecins;
                                } else {
                                    for (Medecin med : medecins) {
                                        boolean matchSearch = (search == null || search.trim().isEmpty()) || med.getNommed().toLowerCase().contains(search.trim().toLowerCase());
                                        boolean matchSpecialite = (specialiteFilter == null || specialiteFilter.isEmpty()) || med.getSpecialite().equals(specialiteFilter);
                                        if (matchSearch && matchSpecialite) {
                                            filteredMedecins.add(med);
                                        }
                                    }
                                }
                                
                                for (Medecin med : filteredMedecins) {
                            %>
                            <div class="col-md-6 mb-3">
                                <div class="card border-primary h-100">
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
                            <input type="datetime-local" class="form-control" id="date_rdv" name="date_rdv" required onchange="validateDate(this)">
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
            // Set minimum date to now
            const now = new Date();
            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const day = String(now.getDate()).padStart(2, '0');
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const minDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
            document.getElementById('date_rdv').min = minDateTime;
        }

        function validateDate(input) {
            const selectedDate = new Date(input.value);
            const now = new Date();
            if (selectedDate < now) {
                alert('Veuillez sélectionner une date et heure future');
                input.value = '';
            }
        }

        function confirmLogout() {
            if (confirm('Êtes-vous sûr de vouloir vous déconnecter?')) {
                window.location.href = 'logout.jsp';
            }
            return false;
        }

        function clearSearchOnReload() {
            if (window.performance && performance.getEntriesByType) {
                const navEntries = performance.getEntriesByType('navigation');
                if (navEntries.length && navEntries[0].type === 'reload') {
                    const params = new URLSearchParams(window.location.search);
                    if (params.has('search') || params.has('specialite')) {
                        window.location.href = window.location.pathname;
                    }
                }
            } else if (performance.navigation && performance.navigation.type === 1) {
                const params = new URLSearchParams(window.location.search);
                if (params.has('search') || params.has('specialite')) {
                    window.location.href = window.location.pathname;
                }
            }
        }

        document.addEventListener('DOMContentLoaded', clearSearchOnReload);
    </script>
</body>
</html>
