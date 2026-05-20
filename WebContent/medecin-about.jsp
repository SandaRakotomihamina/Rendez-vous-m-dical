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
                        <form method="POST" onsubmit="return confirmUpdate()">
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
                            <form method="POST" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.')">
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
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
    <script>
        function confirmLogout() {
            if (confirm('Êtes-vous sûr de vouloir vous déconnecter?')) {
                window.location.href = 'logout.jsp';
            }
            return false;
        }

        function confirmUpdate() {
            return confirm('Êtes-vous sûr de vouloir modifier vos informations?');
        }
    </script>
</body>
</html>