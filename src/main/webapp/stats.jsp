<style>
:root {
    --primary-color: #2c3e50;
    --secondary-color: #3498db;
    --success-color: #27ae60;
    --light-bg: #f8f9fa;
}

body {
    background-color: var(--light-bg);
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}

.navbar {
    background: var(--primary-color) !important;
    box-shadow: 0 2px 15px rgba(0,0,0,0.1);
}

.table {
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    border-radius: 8px;
    overflow: hidden;
}

.card, .stat-card, .quick-action-card {
    border: none;
    border-radius: 12px !important;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    transition: transform 0.3s;
}

.card:hover, .stat-card:hover, .quick-action-card:hover {
    transform: translateY(-5px);
}

.btn {
    border-radius: 8px;
    padding: 8px 20px;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.table thead {
    background: var(--primary-color);
    color: white !important;
}

.chart-container {
    background: white;
    border-radius: 12px;
    padding: 20px;
    margin: 15px 0;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.main-content {
    margin-top: 80px;
    flex: 1;
}

.alert {
    border-radius: 8px;
}
</style>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
  HttpSession userSession = request.getSession(false);
  String role = (userSession != null) ? (String) userSession.getAttribute("role") : null;

  // Autoriser uniquement "responsable" et "administrateur"
  if (userSession == null || !("responsable".equals(role) || "administrateur".equals(role))) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Responsable</title>
  <link rel="icon" type="image/png" href="https://cdn-icons-png.flaticon.com/512/1974/1974346.png">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <style>
    .stat-card {
      background: white;
      border-radius: 15px;
      padding: 20px;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      margin-bottom: 20px;
    }
    .chart-container {
      height: 400px;
      position: relative;
    }
    .nav-custom {
      background: #2c3e50;
      padding: 0.8rem 1.5rem;
      box-shadow: 0 2px 15px rgba(0,0,0,0.1);
    }
    .nav-custom .btn-home {
      border-radius: 50%;
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
  </style>
</head>
<body>

<!-- Barre de navigation -->
<nav class="nav-custom navbar navbar-expand-lg navbar-dark fixed-top">
  <div class="container-fluid">
    <!-- Bouton Accueil -->
    <a class="btn btn-home btn-outline-light me-3"
       href="${pageContext.request.contextPath}/<%= "responsable".equals(role) ? "home" : "adminDashboard.jsp" %>">
      <i class="fas fa-home"></i>
    </a>

    <!-- Titre -->
    <span class="navbar-brand d-none d-md-block">
      <i class="fas fa-chart-line me-2"></i>Tableau de bord statistique
    </span>

    <!-- Menu utilisateur -->
    <div class="ms-auto">
      <div class="dropdown">
        <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
           id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
          <i class="fas fa-user-circle fa-lg me-2"></i>
          <div class="d-none d-sm-block">
            <div class="small">Bonjour </div>
            <strong><%= userSession.getAttribute("login") %></strong>
          </div>
        </a>
        <ul class="dropdown-menu dropdown-menu-end shadow">
          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
          </a></li>
        </ul>
      </div>
    </div>
  </div>
</nav>

<div class="container" style="margin-top: 80px;">
  <!-- Début de la ligne -->
  <div class="row g-4"> <!-- Ajout de gutter (espacement) -->

    <!-- Colonne 1 - Formations par domaine -->
    <div class="col-md-6">
      <div class="stat-card">
        <h4><i class="fas fa-book-open me-2"></i>Formations par domaine</h4>
        <div class="chart-container">
          <canvas id="domainChart"></canvas>
        </div>
      </div>
    </div>

    <!-- Colonne 2 - Participants par profil -->
    <div class="col-md-6">
      <div class="stat-card">
        <h4><i class="fas fa-users me-2"></i>Participants par profil</h4>
        <div class="chart-container">
          <canvas id="profileChart"></canvas>
        </div>
      </div>
    </div>

    <!-- Nouvelle Carte 4 - Budget par domaine -->
    <div class="col-md-6">
      <div class="stat-card">
        <h4><i class="fas fa-coins me-2"></i>Budget par domaine</h4>
        <canvas id="budgetChart"></canvas>
      </div>
    </div>

  </div>
</div>

<script>
  document.addEventListener("DOMContentLoaded", function() {

    // Récupérer les données JSON
    const formationsData = JSON.parse('<c:out value="${formationsParDomaineJSON}" escapeXml="false"/>');
    const participantsData = JSON.parse('<c:out value="${participantsParProfilJSON}" escapeXml="false"/>');
    const budgetData = JSON.parse('${budgetParDomaineJSON}');

    // Graphique "Formations par domaine"
    new Chart(document.getElementById("domainChart"), {
      type: "pie",
      data: {
        labels: Object.keys(formationsData),
        datasets: [{
          data: Object.values(formationsData),
          backgroundColor: ["#4e73df", "#1cc88a", "#36b9cc", "#f6c23e"]
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { position: "bottom" }
        }
      }
    });

    // Graphique "Participants par profil"
    new Chart(document.getElementById("profileChart"), {
      type: "doughnut",
      data: {
        labels: Object.keys(participantsData),
        datasets: [{
          data: Object.values(participantsData),
          backgroundColor: ["#4e73df", "#1cc88a", "#36b9cc"]
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { position: "bottom" }
        }
      }
    });


    // Graphique Budget par domaine (Line Chart)
    new Chart(document.getElementById("budgetChart"), {
      type: "line",
      data: {
        labels: Object.keys(budgetData),
        datasets: [{
          label: "Budget (TND)",
          data: Object.values(budgetData),
          borderColor: "#1cc88a",
          fill: false
        }]
      },
      options: {
        responsive: true,
        plugins: { legend: { position: "bottom" } }
      }
    });
  });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>