<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="dao.MedecinDAO" %>
<%@ page import="models.Medecin" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Rendez-vous Médicaux</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-hospital"></i> Rendez-vous Médical
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="login-patient.jsp">Connexion Patient</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="login-medecin.jsp">Connexion Médecin</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row">
            <div class="col-md-6 offset-md-3 text-center">
                <div class="card shadow">
                    <div class="card-body p-5">
                        <h1 class="mb-4"><i class="fas fa-heartbeat text-danger"></i> Bienvenue</h1>
                        <p class="lead mb-4">Plateforme de gestion des rendez-vous médicaux</p>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <a href="login-patient.jsp" class="btn btn-primary btn-lg btn-block w-100">
                                    <i class="fas fa-user"></i> Patient
                                </a>
                                <p class="small mt-2">Prenez rendez-vous avec un médecin</p>
                            </div>
                            <div class="col-md-6 mb-3">
                                <a href="login-medecin.jsp" class="btn btn-success btn-lg btn-block w-100">
                                    <i class="fas fa-stethoscope"></i> Médecin
                                </a>
                                <p class="small mt-2">Gérez vos rendez-vous</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-5">
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Trouvez un Médecin</h5>
                        <p class="card-text">Recherchez parmi notre réseau de professionnels de santé qualifiés</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Prenez RDV en Ligne</h5>
                        <p class="card-text">Réservez vos rendez-vous facilement et rapidement</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-center">
                    <div class="card-body">
                        <h5 class="card-title">Confirmations par Email</h5>
                        <p class="card-text">Recevez des confirmations et rappels par email instantanément</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer class="text-black text-center py-3 mt-5">
        <p>&copy; <%= java.time.Year.now().getValue() %> Plateforme de Gestion des Rendez-vous Médicaux. Tous droits réservés.</p>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js"></script>
</body>
</html>
