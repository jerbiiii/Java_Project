<%@ page contentType="text/html;charset=UTF-8"  %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Formations</title>
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

        .main-content {
            margin-top: 70px;
            padding: 2rem 0;
        }

        .table-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
            padding: 1.5rem;
        }

        .table thead {
            background: var(--primary-color);
            color: white !important;
        }

        .table-hover tbody tr:hover {
            background-color: rgba(0,0,0,0.03);
        }

        .btn {
            border-radius: 8px;
            padding: 8px 20px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .action-buttons .btn {
            margin: 0 5px;
            min-width: 100px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding: 1rem;
            background: white;
            border-radius: 16px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
        }

        footer {
            margin-top: auto;
            background: var(--dark);
            color: white;
            padding: 1.5rem 0;
        }

        .badge {
            padding: 0.5em 0.75em;
            border-radius: 8px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-dark fixed-top">
    <div class="container-fluid d-flex justify-content-between align-items-center">
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
    <div class="page-header">
        <h2 class="mb-0"><i class="fas fa-book-open me-2"></i>Liste des Formations</h2>
        <div class="d-flex gap-2">
            <c:choose>
                <c:when test="${sessionScope.role == 'administrateur'}">
                    <a href="${pageContext.request.contextPath}/adminDashboard.jsp" class="btn btn-secondary">
                        <i class="fas fa-home me-2"></i>Accueil
                    </a>
                </c:when>
                <c:when test="${sessionScope.role == 'responsable'}">
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                        <i class="fas fa-home me-2"></i>Accueil
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/utilisateurDashboard.jsp" class="btn btn-secondary">
                        <i class="fas fa-home me-2"></i>Accueil
                    </a>
                </c:otherwise>
            </c:choose>
            <a href="${pageContext.request.contextPath}/formations?action=new" class="btn btn-primary">
                <i class="fas fa-plus-circle me-2"></i>Nouvelle Formation
            </a>
        </div>
    </div>

    <div class="table-container">
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="align-middle">
                    <tr>
                        <th>ID</th>
                        <th>Titre</th>
                        <th>Année</th>
                        <th>Durée</th>
                        <th>Domaine</th>
                        <th>Budget</th>
                        <th>Participants</th>
                        <th class="text-end">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="formation" items="${formations}">
                        <tr>
                            <td>${formation.id}</td>
                            <td>${formation.titre}</td>
                            <td>${formation.annee}</td>
                            <td>${formation.duree}</td>
                            <td><span class="badge bg-primary">${formation.domaine.libelle}</span></td>
                            <td>${formation.budget} TND</td>
                            <td>
                                <c:forEach var="participant" items="${formation.participants}">
                                    <span class="badge bg-secondary">${participant.participant.nom}</span>
                                </c:forEach>
                            </td>
                            <td class="text-end action-buttons">
                                <a href="${pageContext.request.contextPath}/formations?action=edit&id=${formation.id}"
                                   class="btn btn-sm btn-warning">
                                    <i class="fas fa-edit me-1"></i>Modifier
                                </a>
                                <a href="${pageContext.request.contextPath}/formations?action=delete&id=${formation.id}"
                                   class="btn btn-sm btn-danger"
                                   onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette formation ?')">
                                    <i class="fas fa-trash-alt me-1"></i>Supprimer
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>