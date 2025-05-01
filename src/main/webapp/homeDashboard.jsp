<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
    HttpSession userSession = request.getSession(false);
    if (userSession == null || !"responsable".equals(userSession.getAttribute("role"))) {
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
            height: 40px;
            margin-right: 10px;
            position: relative;
            top: -1px;
        }

        .main-content {
            margin-top: 70px;
            padding-top: 30px;
        }

        .card, .stat-card {
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            margin-bottom: 2rem;
        }

        .card:hover, .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 25px rgba(0,0,0,0.15);
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

        @keyframes spin { to { transform: rotate(360deg); } }

        .offcanvas-start {
            width: 280px;
            background: var(--primary-color);
            top: 70px;
            height: calc(100vh - 70px);
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

        footer {
            margin-top: 50px;
            padding: 2rem 0;
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
                        <small class="text-muted">Responsable</small>
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
            Tableau de Bord
        </a>
    </div>
</nav>

<div class="offcanvas offcanvas-start text-white" id="sidebarMenu">
    <div class="offcanvas-header border-bottom">
        <h5 class="offcanvas-title">Menu</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas"></button>
    </div>
    <div class="offcanvas-body">
        <nav class="nav flex-column gap-2">
            <a class="nav-link text-white" href="${pageContext.request.contextPath}/stats">
                <i class="fas fa-chart-pie me-2"></i> Statistiques
            </a>
        </nav>
    </div>
</div>


    <main class="container main-content">
        <!-- Nouvelle section de cartes -->
        <div class="row row-cols-1 row-cols-md-2 g-4 mb-5">
            <!-- Carte Statistiques Générales -->
            <div class="col">
                <div class="card h-100 shadow-lg">
                    <div class="card-img-top position-relative">
                        <img src="https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
                             class="w-100" style="height: 180px; object-fit: cover;">
                    </div>
                    <div class="card-body">
                        <h3 class="card-title mb-3">
                            <i class="fas fa-chart-pie me-2"></i>Statistiques Globales
                        </h3>
                        <p class="card-text text-muted">Consultez les indicateurs clés de performance</p>
                        <a href="${pageContext.request.contextPath}/stats" class="btn btn-primary px-4">
                            Accéder <i class="fas fa-arrow-right ms-2"></i>
                        </a>
                    </div>
                </div>
            </div>

            <!-- Carte Statistiques Annuelles -->
            <div class="col">
                <div class="card h-100 shadow-lg">
                    <div class="card-img-top position-relative">
                        <img src="https://images.unsplash.com/photo-1554224155-3a58922a22c3?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
                             class="w-100" style="height: 180px; object-fit: cover;">
                    </div>
                    <div class="card-body">
                        <h3 class="card-title mb-3">
                            <i class="fas fa-chart-line me-2"></i>Statistiques Annuelles
                        </h3>
                        <p class="card-text text-muted">Analysez les tendances sur plusieurs années</p>
                        <a href="${pageContext.request.contextPath}/statsannuelle" class="btn btn-success px-4">
                            Accéder <i class="fas fa-arrow-right ms-2"></i>
                        </a>
                    </div>
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

    });
</script>
</body>
</html>