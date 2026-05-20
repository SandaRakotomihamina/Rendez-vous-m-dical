<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.PatientDAO" %>
<%@ page import="models.Patient" %>

<%
    if (session.getAttribute("patient_id") == null) {
        response.sendRedirect("login-patient.jsp");
        return;
    }

    int patient_id = (Integer) session.getAttribute("patient_id");
    Patient patient = PatientDAO.getPatientById(patient_id);
    
    String action = request.getParameter("action");
    String message = "";
    String messageType = "";

    // Mettre à jour les informations
    if ("update".equals(action)) {
        String nom_pat = request.getParameter("nom_pat");
        String datenais = request.getParameter("datenais");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String mdp = request.getParameter("mdp");
        
        // Vérifier si l'email est déjà utilisé par un autre patient
        if (!email.equals(patient.getEmail()) && PatientDAO.emailExists(email)) {
            message = "Cet email est déjà utilisé par un autre patient.";
            messageType = "danger";
        } else {
            patient.setNom_pat(nom_pat);
            patient.setDatenais(datenais);
            patient.setEmail(email);
            patient.setTelephone(telephone);
            if (!mdp.isEmpty()) {
                patient.setMdp(mdp);
            }
            
            if (PatientDAO.updatePatient(patient, !mdp.isEmpty())) {
                message = "Informations mises à jour avec succès!";
                messageType = "success";
                // Mettre à jour la session
                session.setAttribute("patient_name", nom_pat);
            } else {
                message = "Erreur lors de la mise à jour.";
                messageType = "danger";
            }
        }
    }

    // Supprimer le compte
    if ("delete".equals(action)) {
        if (PatientDAO.deletePatient(patient_id)) {
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
    <title>Mon Profil - Patient</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="patient-dashboard.jsp">
                <i class="fas fa-hospital"></i> Rendez-vous Médical
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item" style="padding-top: 0.5rem;">
                        <span class="navbar-text text-light me-3">
                            <a href="patient-about.jsp" class="text-light text-decoration-none">Bienvenue, <%= session.getAttribute("patient_name") %></a>
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
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">Mon Profil</h5>
                    </div>
                    <div class="card-body">
                        <form method="POST" onsubmit="return confirmUpdate()">
                            <input type="hidden" name="action" value="update">
                            
                            <div class="mb-3">
                                <label for="nom_pat" class="form-label">Nom complet</label>
                                <input type="text" class="form-control" id="nom_pat" name="nom_pat" 
                                       value="<%= patient.getNom_pat() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="datenais" class="form-label">Date de naissance</label>
                                <input type="date" class="form-control" id="datenais" name="datenais" 
                                       value="<%= patient.getDatenais() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="<%= patient.getEmail() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="telephone" class="form-label">Téléphone</label>
                                <input type="tel" class="form-control" id="telephone" name="telephone" 
                                       value="<%= patient.getTelephone() %>" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="mdp" class="form-label">Nouveau mot de passe (laisser vide pour ne pas changer)</label>
                                <input type="password" class="form-control" id="mdp" name="mdp">
                            </div>
                            
                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Mettre à jour</button>
                            </div>
                        </form>
                        
                        <hr class="my-4">
                        
                        <div class="text-center">
                            <h6 class="text-danger">Zone de danger</h6>
                            <p class="text-muted">La suppression du compte est irréversible et supprimera toutes vos données.</p>
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