<%@ page contentType="text/html;charset=UTF-8"  %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
  response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);
  HttpSession userSession = request.getSession(false);
  if (userSession == null || !"administrateur".equals(userSession.getAttribute("role"))) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard - Gestion de Formation</title>
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
      position: relative;
      top: -1px;  /* Fine-tune this value as needed */
    }


    .dashboard-header {
      background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)),
      url('https://images.unsplash.com/photo-1497864149936-d3163f0c0f4b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
      background-size: cover;
      background-position: center;
      height: 400px;
      margin-top: 70px;
      display: flex;
      align-items: center;
      justify-content: center;
      color: white;
      text-align: center;
    }

    .card {
      border: none;
      border-radius: 16px;
      transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
      overflow: hidden;
      box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }

    .card:hover {
      transform: translateY(-8px);
      box-shadow: 0 15px 25px rgba(0,0,0,0.15);
    }

    .card-img-top {
      height: 200px;
      object-fit: cover;
      transition: transform 0.3s ease;
    }

    .navbar-brand img {
      height: 40px;
      margin-right: 10px;
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
  </style>
</head>
<body>

<!-- Loader -->
<div id="loader">
  <div class="spinner"></div>
</div>

<!-- Navbar -->
<nav class="navbar navbar-dark fixed-top">
  <div class="container-fluid d-flex justify-content-between align-items-center">
    <!-- Left Side -->
    <div class="d-flex align-items-center">
      <button class="btn btn-dark me-3" data-bs-toggle="offcanvas" data-bs-target="#sidebarMenu">
        <i class="fas fa-bars"></i>
      </button>
      <div class="dropdown">
            <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
               id="userMenu" data-bs-toggle="dropdown">
              <div class="position-relative me-2">
                <i class="fas fa-user-circle fa-2x"></i>
                <span class="user-status"></span>
              </div>
              <div class="d-flex flex-column">
                <span><%= userSession.getAttribute("login") %></span>
                <small class="text-muted">Administrateur</small>
              </div>
            </a>
            <ul class="dropdown-menu dropdown-menu-end shadow">
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
              </a></li>
            </ul>
          </div>
        </a>
        <ul class="dropdown-menu dropdown-menu-start shadow">
          <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
            <i class="fas fa-sign-out-alt me-2"></i>Déconnexion
          </a></li>
        </ul>

      </div>
      <a class="navbar-brand mx-auto" href="#">
                 <img src="https://cdn-icons-png.flaticon.com/512/1974/1974346.png" alt="Logo">
                    SkillForge
              </a>
    </div>


  </div>

</nav>

<!-- Sidebar -->
<div class="offcanvas offcanvas-start text-white" tabindex="-1" id="sidebarMenu">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title">Menu</h5>
    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
  </div>
  <div class="offcanvas-body">
    <ul class="nav flex-column gap-2">
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/utilisateurs"><i class="fas fa-users me-2"></i>Utilisateurs</a></li>
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/formateurs"><i class="fas fa-chalkboard-teacher me-2"></i>Formateurs</a></li>
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/formations"><i class="fas fa-book-open me-2"></i>Formations</a></li>
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/participants"><i class="fas fa-user-graduate me-2"></i>Participants</a></li>
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/profils"><i class="fas fa-id-badge me-2"></i>Profils</a></li>
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/roles"><i class="fas fa-user-tag me-2"></i>Rôles</a></li>
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/structures"><i class="fas fa-building me-2"></i>Structures</a></li>
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/domaines"><i class="fas fa-layer-group me-2"></i>Domaines</a></li>
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/employeurs"><i class="fas fa-briefcase me-2"></i>Employeurs</a></li>
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/stats"><i class="fas fa-chart-bar me-2"></i>Statistiques</a></li>
      <li class="nav-item"><a class="nav-link text-white" href="${pageContext.request.contextPath}/planification"><i class="fas fa-calendar-alt me-2"></i>Planification</a></li>
    </ul>
  </div>
</div>

<!-- Header -->
<header class="dashboard-header fade-in">
  <div class="container">
    <h1 class="display-4 mb-4">Bienvenue sur la plateforme de gestion de formation</h1>
    <p class="lead mb-4">Optimisez la gestion de vos programmes de formation professionnelle</p>
    <a href="${pageContext.request.contextPath}/formations" class="btn btn-light btn-lg rounded-pill px-4">
          <i class="fas fa-arrow-right me-2"></i>Commencer
        </a>
    </a>
  </div>
</header>

<!-- Main Content -->
<!-- Main Content -->
<main class="container my-5">
  <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">

    <!-- Formateurs Card -->
    <div class="col fade-in">
      <div class="card h-100 shadow-lg">
        <div class="card-img-top position-relative">
          <img src="https://images.unsplash.com/photo-1580894732444-8ecded7900cd?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
               class="w-100 h-100" style="object-fit: cover;">
          <div class="card-overlay"></div>
        </div>
        <div class="card-body">
          <h3 class="card-title mb-3">
            <i class="fas fa-chalkboard-teacher me-2"></i>Formateurs
          </h3>
          <p class="card-text text-muted">Gérez les profils des formateurs et leurs disponibilités</p>
          <a href="${pageContext.request.contextPath}/formateurs" class="btn btn-primary px-4">
            Accéder <i class="fas fa-arrow-right ms-2"></i>
          </a>
        </div>
      </div>
    </div>

    <!-- Participants Card -->
    <div class="col fade-in">
      <div class="card h-100 shadow-lg">
        <div class="card-img-top position-relative">
          <img src="https://images.unsplash.com/photo-1582213782179-e0d53f98f2ca?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
               class="w-100 h-100" style="object-fit: cover;">
          <div class="card-overlay"></div>
        </div>
        <div class="card-body">
          <h3 class="card-title mb-3">
            <i class="fas fa-user-graduate me-2"></i>Participants
          </h3>
          <p class="card-text text-muted">Suivez les inscriptions et les progrès des participants</p>
          <a href="${pageContext.request.contextPath}/participants" class="btn btn-success px-4">
            Accéder <i class="fas fa-arrow-right ms-2"></i>
          </a>
        </div>
      </div>
    </div>

    <!-- Planning Card -->
    <div class="col fade-in">
      <div class="card h-100 shadow-lg">
        <div class="card-img-top position-relative">
          <img src="https://images.unsplash.com/photo-1542744095-291d1f67b221?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
               class="w-100 h-100" style="object-fit: cover;">
          <div class="card-overlay"></div>
        </div>
        <div class="card-body">
          <h3 class="card-title mb-3">
            <i class="fas fa-calendar-alt me-2"></i>Planning
          </h3>
          <p class="card-text text-muted">Consultez et planifiez les sessions de formation</p>
          <a href="${pageContext.request.contextPath}/formationsPlanifiees" class="btn btn-info px-4">
            Accéder <i class="fas fa-arrow-right ms-2"></i>
          </a>
        </div>
      </div>
    </div>
  </div>
</main>


<!-- Footer -->
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