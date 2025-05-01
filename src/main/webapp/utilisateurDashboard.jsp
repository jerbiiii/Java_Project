<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);
  HttpSession userSession = request.getSession(false);
  if (userSession == null || !"simple_utilisateur".equals(userSession.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Utilisateur - Gestion</title>
  <link rel="icon" type="image/png" href="https://cdn-icons-png.flaticon.com/512/1974/1974346.png">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
  <style>
    :root {
      --primary-color: #2c3e50;
      --secondary-color: #3498db;
      --success-color: #27ae60;
      --light-bg: #f8f9fa;
      --dark: #1e293b;
    }
    /* Add to user dashboard's style section */
    .main-content {
      margin-top: 70px;
      padding-top: 30px;
    }

    .quick-action-card {
      margin-bottom: 30px;
      padding: 30px;
    }
/* Add consistent spacing between sections */
.card, .quick-action-card {
  margin-bottom: 2rem;
}

/* Better spacing for footer */
footer {
  margin-top: 50px;
  padding: 2rem 0;
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
      height: 70px;
    }

    .navbar-brand img {
      height: 40px;
      margin-right: 10px;
      position: relative;
      top: -1px;
    }

    #loader {
      position: fixed;
      z-index: 9999;
      background: #f8f9fa;
      width: 100%;
      height: 100%;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .spinner {
      width: 60px;
      height: 60px;
      border: 8px solid #007bff;
      border-top: 8px solid transparent;
      border-radius: 50%;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    .fade-in {
      opacity: 0;
      transform: translateY(20px);
      animation: fadeInUp 0.6s ease forwards;
    }

    @keyframes fadeInUp {
      to { opacity: 1; transform: translateY(0); }
    }

    .offcanvas-start {
      width: 280px;
      background: var(--primary-color);
    }

    .nav-link {
      padding: 12px 20px;
      border-radius: 8px;
      transition: all 0.3s ease;
    }

    .nav-link:hover,
    .nav-link.active {
      background: rgba(255,255,255,0.1);
    }

    .quick-action-card {
      background: white;
      border-radius: 16px;
      padding: 25px;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
      transition: transform 0.3s;
      text-align: center;
      height: 100%;
    }

    .quick-action-card:hover {
      transform: translateY(-8px);
      box-shadow: 0 15px 25px rgba(0,0,0,0.15);
    }
  </style>
</head>
<body>

<!-- Loader -->
<div id="loader">
  <div class="spinner"></div>
</div>

<nav class="navbar navbar-dark fixed-top">
  <div class="container-fluid d-flex justify-content-between align-items-center">
    <div class="d-flex align-items-center">
      <button class="btn btn-dark me-3" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu">
        <i class="fas fa-bars"></i>
      </button>
      <div class="dropdown">
        <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
           id="userDropdown" data-bs-toggle="dropdown">
          <div class="position-relative me-2">
            <i class="fas fa-user-circle fa-2x"></i>
          </div>
          <div class="d-flex flex-column">
            <span><%= userSession.getAttribute("login") %></span>
            <small class="text-muted">Utilisateur</small>
          </div>
        </a>
        <ul class="dropdown-menu dropdown-menu-end shadow">
          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
          </a></li>
        </ul>
      </div>
    </div>

    <a class="navbar-brand mx-auto" href="#">
      <img src="https://cdn-icons-png.flaticon.com/512/1974/1974346.png" alt="Logo">
      Espace Utilisateur
    </a>
  </div>
</nav>


<div class="offcanvas offcanvas-start text-white" tabindex="-1" id="sidebarMenu">
  <div class="offcanvas-header border-bottom">
    <h5 class="offcanvas-title">Menu Rapide</h5>
    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
  </div>
  <div class="offcanvas-body">
    <nav class="nav flex-column gap-2">
      <a class="nav-link text-white" href="${pageContext.request.contextPath}/formateurs">
        <i class="fas fa-chalkboard-teacher me-2"></i>Formateurs
      </a>
      <a class="nav-link text-white" href="${pageContext.request.contextPath}/formations">
        <i class="fas fa-book-open me-2"></i>Formations
      </a>
      <a class="nav-link text-white" href="${pageContext.request.contextPath}/participants">
        <i class="fas fa-user-graduate me-2"></i>Participants
      </a>
      <a class="nav-link text-white" href="${pageContext.request.contextPath}/planification">
        <i class="fas fa-calendar-alt me-2"></i>Planification
      </a>
    </nav>
  </div>
</div>
<!-- Main Content -->

<main class="container main-content fade-in">
  <div class="row row-cols-1 row-cols-md-2 row-cols-xl-4 g-4">
    <div class="col">
      <div class="quick-action-card">
        <i class="fas fa-user-plus fa-3x text-primary mb-3"></i>
        <h5>Nouveau Formateur</h5>
        <a href="${pageContext.request.contextPath}/formateurs?action=new" class="btn btn-primary mt-2">Ajouter</a>
      </div>
    </div>

    <div class="col">
      <div class="quick-action-card">
        <i class="fas fa-calendar-plus fa-3x text-success mb-3"></i>
        <h5>Nouvelle Formation</h5>
        <a href="${pageContext.request.contextPath}/formations?action=new" class="btn btn-success mt-2">Créer</a>
      </div>
    </div>

    <div class="col">
      <div class="quick-action-card">
        <i class="fas fa-user-check fa-3x text-info mb-3"></i>
        <h5>Inscrire Participant</h5>
        <a href="${pageContext.request.contextPath}/participants?action=new" class="btn btn-info mt-2">Inscrire</a>
      </div>
    </div>

    <div class="col">
      <div class="quick-action-card">
        <i class="fas fa-calendar-alt fa-3x text-warning mb-3"></i>
        <h5>Formations Planifiées</h5>
        <a href="${pageContext.request.contextPath}/formationsPlanifiees" class="btn btn-warning mt-2">
          Voir le planning
        </a>
      </div>
    </div>
  </div>
</main>

<footer class="bg-dark text-white mt-auto">
  <div class="container py-4">
    <div class="text-center">
      <img src="https://cdn-icons-png.flaticon.com/512/1974/1974346.png" alt="Logo" width="40" class="mb-2">
      <p class="mb-0">SkillForge &copy; 2025 | Tous droits réservés</p>
    </div>
  </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  window.addEventListener("load", function() {
    const loader = document.getElementById("loader");
    loader.style.opacity = 0;
    setTimeout(() => loader.style.display = "none", 500);

    document.querySelectorAll('.fade-in').forEach(el => {
      el.style.opacity = 1;
      el.style.transform = 'translateY(0)';
    });
  });
</script>
</body>
</html>