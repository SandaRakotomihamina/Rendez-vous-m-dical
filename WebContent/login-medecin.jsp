<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.MedecinDAO" %>
<%@ page import="models.Medecin" %>

<%
    String message = "";
    String messageType = "";
    
    if (request.getMethod().equals("POST")) {
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        String mdp = request.getParameter("mdp");
        
        if ("login".equals(action)) {
            Medecin medecin = MedecinDAO.authenticateMedecin(email, mdp);
            if (medecin != null) {
                session.setAttribute("medecin_id", medecin.getIdmed());
                session.setAttribute("medecin_name", medecin.getNommed());
                session.setAttribute("medecin_email", medecin.getEmail());
                session.setAttribute("medecin_specialite", medecin.getSpecialite());
                response.sendRedirect("medecin-dashboard.jsp");
            } else {
                message = "Email ou mot de passe incorrect";
                messageType = "danger";
            }
        } else if ("register".equals(action)) {
            String nommed = request.getParameter("nommed");
            String specialite = request.getParameter("specialite");
            int taux_horaire = Integer.parseInt(request.getParameter("taux_horaire"));
            String lieu = request.getParameter("lieu");
            String telephone = request.getParameter("telephone");
            String bio = request.getParameter("bio");
            String horaire_journalier = request.getParameter("horaire_journalier");
            String jours_travail = request.getParameter("jours_travail");
            
            if (MedecinDAO.emailExists(email)) {
                message = "Cet email est déjà utilisé";
                messageType = "warning";
            } else {
                Medecin newMedecin = new Medecin(nommed, specialite, taux_horaire, lieu, email, telephone, mdp, horaire_journalier, jours_travail);
                newMedecin.setBio(bio);
                if (MedecinDAO.addMedecin(newMedecin)) {
                    message = "Inscription réussie! Connectez-vous maintenant.";
                    messageType = "success";
                } else {
                    message = "Erreur lors de l'inscription";
                    messageType = "danger";
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion Médecin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-success">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-hospital"></i> Rendez-vous Médical
            </a>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row">
            <div class="col-md-6 offset-md-3">
                <% if (!message.isEmpty()) { %>
                    <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                        <%= message %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <% } %>

                <!-- Connexion -->
                <div class="card shadow mb-4" id="loginForm">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0">Connexion Médecin</h4>
                    </div>
                    <div class="card-body">
                        <form method="POST">
                            <input type="hidden" name="action" value="login">
                            <div class="mb-3">
                                <label for="login_email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="login_email" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="login_mdp" class="form-label">Mot de passe</label>
                                <input type="password" class="form-control" id="login_mdp" name="mdp" required>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Se Connecter</button>
                        </form>
                        <div class="text-center mt-3">
                            <a href="#" onclick="showRegisterForm()" class="text-decoration-none">Créer un compte</a>
                        </div>
                    </div>
                </div>

                <!-- Inscription -->
                <div class="card shadow" id="registerForm" style="display: none;">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0">Créer un Compte Médecin</h4>
                    </div>
                    <div class="card-body">
                        <form method="POST" class="availability-form">
                            <input type="hidden" name="action" value="register">
                            <div class="mb-3">
                                <label for="nommed" class="form-label">Nom Complet</label>
                                <input type="text" class="form-control" id="nommed" name="nommed" required>
                            </div>
                            <div class="mb-3">
                                <label for="specialite" class="form-label">Spécialité</label>
                                <input type="text" class="form-control" id="specialite" name="specialite" required>
                            </div>
                            <div class="mb-3">
                                <label for="taux_horaire" class="form-label">Taux Horaire (en DH)</label>
                                <input type="number" class="form-control" id="taux_horaire" name="taux_horaire" required>
                            </div>
                            <div class="mb-3">
                                <label for="lieu" class="form-label">Lieu de Consultation</label>
                                <input type="text" class="form-control" id="lieu" name="lieu" required>
                            </div>
                            <div class="mb-3">
                                <label for="register_email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="register_email" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="telephone" class="form-label">Téléphone</label>
                                <input type="tel" class="form-control" id="telephone" name="telephone">
                            </div>
                            <div class="row gx-3 mb-3">
                                <div class="col-md-6">
                                    <label for="horaire_debut" class="form-label">Début d'horaire</label>
                                    <input type="time" class="form-control" id="horaire_debut" name="horaire_debut">
                                </div>
                                <div class="col-md-6">
                                    <label for="horaire_fin" class="form-label">Fin d'horaire</label>
                                    <input type="time" class="form-control" id="horaire_fin" name="horaire_fin">
                                </div>
                            </div>
                            <input type="hidden" id="horaire_journalier" name="horaire_journalier">
                            <div class="mb-3">
                                <label class="form-label">Jours de travail</label>
                                <div class="day-selector" id="registerDaySelector">
                                    <span class="day-chip" data-day="Lundi">Lundi</span>
                                    <span class="day-chip" data-day="Mardi">Mardi</span>
                                    <span class="day-chip" data-day="Mercredi">Mercredi</span>
                                    <span class="day-chip" data-day="Jeudi">Jeudi</span>
                                    <span class="day-chip" data-day="Vendredi">Vendredi</span>
                                    <span class="day-chip" data-day="Samedi">Samedi</span>
                                    <span class="day-chip" data-day="Dimanche">Dimanche</span>
                                </div>
                            </div>
                            <input type="hidden" id="register_jours_travail" name="jours_travail">
                            <div class="mb-3">
                                <label for="bio" class="form-label">Biographie</label>
                                <textarea class="form-control" id="bio" name="bio" rows="3"></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="register_mdp" class="form-label">Mot de passe</label>
                                <input type="password" class="form-control" id="register_mdp" name="mdp" required>
                            </div>
                            <button type="submit" class="btn btn-info w-100">S'inscrire</button>
                        </form>
                        <div class="text-center mt-3">
                            <a href="#" onclick="showLoginForm()" class="text-decoration-none">Se connecter à mon compte</a>
                        </div>
                    </div>
                </div>

                <div class="text-center mt-3">
                    <a href="index.jsp" class="btn btn-outline-secondary">Retour à l'accueil</a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/script.js"></script>
    <script>
        function showRegisterForm() {
            document.getElementById('loginForm').style.display = 'none';
            document.getElementById('registerForm').style.display = 'block';
        }
        
        function showLoginForm() {
            document.getElementById('registerForm').style.display = 'none';
            document.getElementById('loginForm').style.display = 'block';
        }
    </script>
</body>
</html>
