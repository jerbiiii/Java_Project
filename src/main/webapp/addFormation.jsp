<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Formation</title>
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

        .form-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            padding: 2rem;
            max-width: 800px;
            margin: 0 auto;
        }

        .card-header {
            background: var(--primary-color);
            color: white;
            border-radius: 16px 16px 0 0 !important;
            padding: 1.5rem;
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

        .form-check-label {
            margin-left: 8px;
        }

        footer {
            margin-top: auto;
            background: var(--dark);
            color: white;
            padding: 1.5rem 0;
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

<main class="main-content fade-in">
    <div class="form-container">
        <div class="card shadow-sm">
            <div class="card-header">
                <h3 class="mb-0">
                    <i class="fas fa-book-open me-2"></i>
                    ${not empty formation ? 'Modifier' : 'Ajouter'} Formation
                </h3>
            </div>
            <div class="card-body p-4">
                <form action="formations" method="post">
                    <input type="hidden" name="action" value="add">
                    <c:if test="${not empty formation}">
                        <input type="hidden" name="id" value="${formation.id}">
                    </c:if>

                    <div class="row g-4">
                        <!-- Titre -->
                        <div class="col-md-12">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Titre</label>
                                <input type="text" name="titre" value="${formation.titre}"
                                       class="form-control form-control-lg" required>
                            </div>
                        </div>

                        <!-- Domaine -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Domaine</label>
                                <select name="domaineId" class="form-select form-select-lg">
                                    <c:forEach items="${domaines}" var="domaine">
                                        <option value="${domaine.id}" ${formation.domaine.id == domaine.id ? 'selected' : ''}>
                                            ${domaine.libelle}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <!-- Année -->
                        <div class="col-md-3">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Année</label>
                                <input type="number" name="annee" value="${formation.annee}"
                                       class="form-control form-control-lg" min="2024" max="2100" required>
                            </div>
                        </div>

                        <!-- Durée -->
                        <div class="col-md-3">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Durée (jours)</label>
                                <input type="number" name="duree" value="${formation.duree}"
                                       class="form-control form-control-lg" min="1" required>
                            </div>
                        </div>

                        <!-- Budget -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Budget (TND)</label>
                                <input type="number" name="budget" value="${formation.budget}"
                                       class="form-control form-control-lg" step="any" required>
                            </div>
                        </div>

                        <!-- Participants -->
                        <div class="col-12">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Participants</label>
                                <div class="row g-3">
                                    <c:forEach items="${participants}" var="participant">
                                        <div class="col-md-4">
                                            <div class="form-check ps-4">
                                                <input class="form-check-input"
                                                       type="checkbox"
                                                       name="participantId"
                                                       value="${participant.id}"
                                                <c:forEach items="${formation.participants}" var="fp">
                                                    ${fp.participant.id == participant.id ? 'checked' : ''}
                                                </c:forEach>
                                                       id="participant_${participant.id}">
                                                <label class="form-check-label">
                                                        ${participant.nom} ${participant.prenom}
                                                </label>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-3 mt-4">
                        <a href="${pageContext.request.contextPath}/formations"
                           class="btn btn-secondary">
                            <i class="fas fa-times me-2"></i>Annuler
                        </a>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-save me-2"></i>Enregistrer
                        </button>
                    </div>
                </form>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    window.addEventListener("load", function() {
        document.querySelectorAll('.fade-in').forEach(el => {
            el.style.opacity = 1;
            el.style.transform = 'translateY(0)';
        });
    });
</script>
</body>
</html>