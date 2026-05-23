<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.MedecinDAO" %>
<%@ page import="models.Medecin" %>

<%
    if (session.getAttribute("medecin_id") == null) {
        response.sendRedirect("login-medecin.jsp");
        return;
    }

    int medecin_id = (Integer) session.getAttribute("medecin_id");
    Medecin medecin = MedecinDAO.getMedecinById(medecin_id);
    
    String rawHoraire = medecin.getHoraire_journalier();
    String horaireDebut = "";
    String horaireFin = "";
    if (rawHoraire != null && rawHoraire.contains("-")) {
        String[] parts = rawHoraire.split("-");
        if (parts.length == 2) {
            horaireDebut = parts[0];
            horaireFin = parts[1];
        }
    }
    String joursTravail = medecin.getJours_travail() != null ? medecin.getJours_travail() : "";
    
    String action = request.getParameter("action");
    String message = "";
    String messageType = "";

    // Mettre à jour les informations
    if ("update".equals(action)) {
        String nommed = request.getParameter("nommed");
        String specialite = request.getParameter("specialite");
        int taux_horaire = Integer.parseInt(request.getParameter("taux_horaire"));
        String lieu = request.getParameter("lieu");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String bio = request.getParameter("bio");
        String horaire_journalier = request.getParameter("horaire_journalier");
        String jours_travail = request.getParameter("jours_travail");
        String mdp = request.getParameter("mdp");
        
        // Vérifier si l'email est déjà utilisé par un autre médecin
        if (!email.equals(medecin.getEmail()) && MedecinDAO.emailExists(email)) {
            message = "Cet email est déjà utilisé par un autre médecin.";
            messageType = "danger";
        } else {
            medecin.setNommed(nommed);
            medecin.setSpecialite(specialite);
            medecin.setTaux_horaire(taux_horaire);
            medecin.setLieu(lieu);
            medecin.setEmail(email);
            medecin.setTelephone(telephone);
            medecin.setBio(bio);
            medecin.setHoraire_journalier(horaire_journalier);
            medecin.setJours_travail(jours_travail);
            if (!mdp.isEmpty()) {
                medecin.setMdp(mdp);
            }
            
            if (MedecinDAO.updateMedecin(medecin, !mdp.isEmpty())) {
                message = "Informations mises à jour avec succès!";
                messageType = "success";
                // Mettre à jour la session
                session.setAttribute("medecin_name", nommed);
            } else {
                message = "Erreur lors de la mise à jour.";
                messageType = "danger";
            }
        }
    }

    // Supprimer le compte
    if ("delete".equals(action)) {
        if (MedecinDAO.deleteMedecin(medecin_id)) {
            session.invalidate();
            response.sendRedirect("index.jsp?message=Compte supprimé avec succès");
            return;
        } else {
            message = "Erreur lors de la suppression du compte.";
            messageType = "danger";
        }
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - Médecin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="medecin-dashboard.jsp">
                <i class="fas fa-hospital"></i> Rendez-vous Médical
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item" style="padding-top: 0.5rem;">
                        <span class="navbar-text text-light me-3">
                            <a href="medecin-about.jsp" class="text-light text-decoration-none">Dr. <%= session.getAttribute("medecin_name") %></a>
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

        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">Mon Profil</h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" class="availability-form" data-confirm="Êtes-vous sûr de vouloir modifier vos informations ?">
                            <input type="hidden" name="action" value="update">
                            
                            <div class="mb-3">
                                <label for="nommed" class="form-label">Nom complet</label>
                                <input type="text" class="form-control" id="nommed" name="nommed" 
                                       value="<%= medecin.getNommed() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="specialite" class="form-label">Spécialité</label>
                                <input type="text" class="form-control" id="specialite" name="specialite" 
                                       value="<%= medecin.getSpecialite() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="taux_horaire" class="form-label">Taux horaire (DH)</label>
                                <input type="number" class="form-control" id="taux_horaire" name="taux_horaire" 
                                       value="<%= medecin.getTaux_horaire() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="lieu" class="form-label">Lieu</label>
                                <input type="text" class="form-control" id="lieu" name="lieu" 
                                       value="<%= medecin.getLieu() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="<%= medecin.getEmail() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="telephone" class="form-label">Téléphone</label>
                                <input type="tel" class="form-control" id="telephone" name="telephone" 
                                       value="<%= medecin.getTelephone() %>" required>
                            </div>
                            
                            <div class="row gx-3 mb-3">
                                <div class="col-md-6">
                                    <label for="horaire_debut" class="form-label">Début d'horaire</label>
                                    <input type="time" class="form-control" id="horaire_debut" name="horaire_debut" value="<%= horaireDebut %>">
                                </div>
                                <div class="col-md-6">
                                    <label for="horaire_fin" class="form-label">Fin d'horaire</label>
                                    <input type="time" class="form-control" id="horaire_fin" name="horaire_fin" value="<%= horaireFin %>">
                                </div>
                            </div>
                            <input type="hidden" id="horaire_journalier" name="horaire_journalier" value="<%= medecin.getHoraire_journalier() != null ? medecin.getHoraire_journalier() : "" %>">
                            <div class="mb-3">
                                <label class="form-label">Jours de travail</label>
                                <div class="day-selector" id="editDaySelector">
                                    <span class="day-chip<%= joursTravail.contains("Lundi") ? " selected" : "" %>" data-day="Lundi">Lundi</span>
                                    <span class="day-chip<%= joursTravail.contains("Mardi") ? " selected" : "" %>" data-day="Mardi">Mardi</span>
                                    <span class="day-chip<%= joursTravail.contains("Mercredi") ? " selected" : "" %>" data-day="Mercredi">Mercredi</span>
                                    <span class="day-chip<%= joursTravail.contains("Jeudi") ? " selected" : "" %>" data-day="Jeudi">Jeudi</span>
                                    <span class="day-chip<%= joursTravail.contains("Vendredi") ? " selected" : "" %>" data-day="Vendredi">Vendredi</span>
                                    <span class="day-chip<%= joursTravail.contains("Samedi") ? " selected" : "" %>" data-day="Samedi">Samedi</span>
                                    <span class="day-chip<%= joursTravail.contains("Dimanche") ? " selected" : "" %>" data-day="Dimanche">Dimanche</span>
                                </div>
                            </div>
                            <input type="hidden" id="edit_jours_travail" name="jours_travail" value="<%= joursTravail %>">
                            <div class="mb-3">
                                <label for="bio" class="form-label">Biographie</label>
                                <textarea class="form-control" id="bio" name="bio" rows="3"><%= medecin.getBio() != null ? medecin.getBio() : "" %></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label for="mdp" class="form-label">Nouveau mot de passe (laisser vide pour ne pas changer)</label>
                                <input type="password" class="form-control" id="mdp" name="mdp">
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-success">Mettre à jour</button>
                            </div>
                        </form>
                        
                        <hr class="my-4">
                        
                        <div class="text-center">
                            <h6 class="text-danger">Zone de danger</h6>
                            <p class="text-muted">La suppression du compte est irréversible et supprimera toutes vos données et rendez-vous.</p>
                            <form method="POST" data-confirm="Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.">
                                <input type="hidden" name="action" value="delete">
                                <button type="submit" class="btn btn-danger">Supprimer mon compte</button>
                            </form>
                        </div>
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