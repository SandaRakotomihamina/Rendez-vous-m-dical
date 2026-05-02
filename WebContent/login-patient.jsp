<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.PatientDAO" %>
<%@ page import="models.Patient" %>

<%
    String message = "";
    String messageType = "";
    
    if (request.getMethod().equals("POST")) {
        String action = request.getParameter("action");
        String email = request.getParameter("email");
        String mdp = request.getParameter("mdp");
        
        if ("login".equals(action)) {
            Patient patient = PatientDAO.authenticatePatient(email, mdp);
            if (patient != null) {
                session.setAttribute("patient_id", patient.getIdpat());
                session.setAttribute("patient_name", patient.getNom_pat());
                session.setAttribute("patient_email", patient.getEmail());
                response.sendRedirect("patient-dashboard.jsp");
            } else {
                message = "Email ou mot de passe incorrect";
                messageType = "danger";
            }
        } else if ("register".equals(action)) {
            String nom_pat = request.getParameter("nom_pat");
            String datenais = request.getParameter("datenais");
            String telephone = request.getParameter("telephone");
            
            if (PatientDAO.emailExists(email)) {
                message = "Cet email est déjà utilisé";
                messageType = "warning";
            } else {
                Patient newPatient = new Patient(nom_pat, datenais, email, telephone, mdp);
                if (PatientDAO.addPatient(newPatient)) {
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
    <title>Connexion Patient</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
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
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">Connexion Patient</h4>
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
                            <button type="submit" class="btn btn-primary w-100">Se Connecter</button>
                        </form>
                        <div class="text-center mt-3">
                            <a href="#" onclick="showRegisterForm()" class="text-decoration-none">Créer un compte</a>
                        </div>
                    </div>
                </div>

                <!-- Inscription -->
                <div class="card shadow" id="registerForm" style="display: none;">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0">Créer un Compte</h4>
                    </div>
                    <div class="card-body">
                        <form method="POST">
                            <input type="hidden" name="action" value="register">
                            <div class="mb-3">
                                <label for="nom_pat" class="form-label">Nom Complet</label>
                                <input type="text" class="form-control" id="nom_pat" name="nom_pat" required>
                            </div>
                            <div class="mb-3">
                                <label for="datenais" class="form-label">Date de Naissance</label>
                                <input type="date" class="form-control" id="datenais" name="datenais" required>
                            </div>
                            <div class="mb-3">
                                <label for="register_email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="register_email" name="email" required>
                            </div>
                            <div class="mb-3">
                                <label for="telephone" class="form-label">Téléphone</label>
                                <input type="tel" class="form-control" id="telephone" name="telephone">
                            </div>
                            <div class="mb-3">
                                <label for="register_mdp" class="form-label">Mot de passe</label>
                                <input type="password" class="form-control" id="register_mdp" name="mdp" required>
                            </div>
                            <button type="submit" class="btn btn-success w-100">S'inscrire</button>
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
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
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
