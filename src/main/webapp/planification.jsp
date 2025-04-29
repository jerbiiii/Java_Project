<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    HttpSession userSession = request.getSession(false);
    String role = (userSession != null) ? (String) userSession.getAttribute("role") : null;

    // Autoriser uniquement "utilisateur" et "administrateur"
    if (userSession == null || !("simple_utilisateur".equals(role) || "administrateur".equals(role))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Planification des Formations</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
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

        .main-content {
            margin-top: 70px;
            padding: 2rem 0;
            flex: 1;
        }

        .table-container {
            background: white;
            border-radius: 18px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
            padding: 2rem;
        }

        .card-header {
            background: var(--primary-color);
            color: white;
            border-radius: 18px 18px 0 0 !important;
            padding: 1.75rem;
        }

        .form-control, .form-select {
            padding: 0.75rem 1rem;
            font-size: 1rem;
            border-radius: 10px !important;
        }

        .select2-container--default .select2-selection--single {
            height: 48px;
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
        }

        .select2-container--default .select2-selection__arrow {
            height: 46px;
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
        }
        .nav-custom .navbar-brand {
            display: flex !important;
            align-items: center;
            gap: 12px;
            font-size: 1.25rem;
            margin-left: 1rem;
        }

        .nav-custom .navbar-brand img {
            height: 40px;
            transition: transform 0.3s;
        }

        .nav-custom .navbar-brand:hover img {
            transform: scale(1.05);
        }
    </style>
</head>
<body>

<nav class="navbar navbar-dark fixed-top">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <!-- Bouton Accueil -->
        <a class="btn btn-home btn-outline-light me-3"
           href="${pageContext.request.contextPath}/<%= "simple_utilisateur".equals(role) ? "utilisateurDashboard.jsp" : "adminDashboard.jsp" %>">
            <i class="fas fa-home"></i>
        </a>
        <!-- Menu Utilisateur -->
        <div class="d-flex align-items-center">
            <div class="dropdown">
                <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
                   id="userDropdown" data-bs-toggle="dropdown">
                    <div class="position-relative me-2">
                        <i class="fas fa-user-circle fa-2x"></i>
                    </div>
                    <div class="d-flex flex-column">
                        <span>${sessionScope.login}</span>
                        <small class="text-muted">${sessionScope.role}</small>
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
            <img src="https://cdn-icons-png.flaticon.com/512/1974/1974346.png" alt="Logo" style="height:40px">
            Gestion des Formations
        </a>
    </div>
</nav>

<main class="container main-content fade-in">
    <div class="table-container">
        <div class="card shadow-sm">
            <div class="card-header">
                <h3 class="mb-0">
                    <i class="fas fa-calendar-alt me-2"></i>
                    Planification de Formation
                </h3>
            </div>
            <div class="card-body p-4">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    Sélectionnez une formation et complétez les détails
                </div>

                <form action="${pageContext.request.contextPath}/planification" method="post">
                    <!-- Sélection de la formation -->
                    <div class="mb-4">
                        <label class="form-label fw-bold">Formation à planifier :</label>
                        <select name="formationId" class="form-select select2-formation" required>
                            <option value="">Choisir une formation...</option>
                            <c:forEach items="${formationsNonPlanifiees}" var="formation">
                                <option value="${formation.id}">
                                        ${formation.titre} (${formation.domaine.libelle} - ${formation.annee})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Sélection du formateur -->
                    <div class="mb-4">
                        <label class="form-label fw-bold">Formateur :</label>
                        <select name="formateurId" class="form-select select2-formateur" required>
                            <option value="">Choisir un formateur...</option>
                            <c:forEach items="${formateurs}" var="formateur">
                                <option value="${formateur.id}">
                                        ${formateur.nom} ${formateur.prenom} (${formateur.type})
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Dates et lieu -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Date de début :</label>
                            <input type="date" name="dateDebut" class="form-control form-control-lg" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Date de fin :</label>
                            <input type="date" name="dateFin" class="form-control form-control-lg" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Lieu :</label>
                            <input type="text" name="lieu" class="form-control form-control-lg" required>
                        </div>
                    </div>

                    <!-- Validation -->
                    <div class="d-grid">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-calendar-check me-2"></i>Planifier
                        </button>
                    </div>
                </form>

                <c:if test="${not empty success}">
                    <div class="alert alert-success mt-4">
                        <i class="fas fa-check-circle me-2"></i>${success}
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-dark text-white">
    <div class="container text-center py-3">
        <img src="https://cdn-icons-png.flaticon.com/512/1974/1974346.png" alt="Logo" width="40" class="mb-2">
        <p class="mb-0">SkillForge &copy; 2025 | Tous droits réservés</p>
    </div>
</footer>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
<script>
    $(document).ready(function() {
        $('.select2-formation').select2({
            placeholder: "Rechercher une formation...",
            allowClear: true,
            width: '100%'
        });

        $('.select2-formateur').select2({
            placeholder: "Rechercher un formateur...",
            allowClear: true,
            width: '100%'
        });

        $('form').submit(function(e) {
            const debut = new Date($('[name="dateDebut"]').val());
            const fin = new Date($('[name="dateFin"]').val());

            if(debut >= fin) {
                alert('La date de fin doit être postérieure à la date de début !');
                e.preventDefault();
            }
        });
    });
</script>
</body>
</html>