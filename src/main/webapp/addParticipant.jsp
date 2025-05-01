<%@ page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Participant</title>
    <link rel="icon" type="image/png" href="https://cdn-icons-png.flaticon.com/512/1974/1974346.png">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --success-color: #27ae60;
            --error-color: #dc3545;
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

        footer {
            margin-top: auto;
            background: var(--dark);
            color: white;
            padding: 1.5rem 0;
        }

        .invalid-feedback {
            color: var(--error-color);
            font-size: 0.85em;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-dark fixed-top">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center">
            <div class="dropdown">
                <a href="#" class="d-flex align-items-center text-white text-decoration-none dropdown-toggle" id="userDropdown" data-bs-toggle="dropdown">
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
                    <i class="fas fa-user-graduate me-2"></i>
                    ${not empty participant ? 'Modifier' : 'Ajouter'} Participant
                </h3>
            </div>
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/participants" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="action" value="add">
                    <c:if test="${not empty participant}">
                        <input type="hidden" name="id" value="${participant.id}">
                    </c:if>

                    <div class="row g-4">
                        <!-- Nom -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Nom</label>
                                <input type="text" name="nom" value="${participant.nom}"
                                       class="form-control form-control-lg"
                                       pattern="^[A-Za-zÀ-ÿ\s\-']{2,50}$"
                                       title="2-50 caractères alphabétiques"
                                       required>
                                <div class="invalid-feedback">
                                    Format invalide (lettres, accents et traits d'union uniquement)
                                </div>
                            </div>
                        </div>

                        <!-- Prénom -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Prénom</label>
                                <input type="text" name="prenom" value="${participant.prenom}"
                                       class="form-control form-control-lg"
                                       pattern="^[A-Za-zÀ-ÿ\s\-']{2,50}$"
                                       title="2-50 caractères alphabétiques"
                                       required>
                                <div class="invalid-feedback">
                                    Format invalide (lettres, accents et traits d'union uniquement)
                                </div>
                            </div>
                        </div>

                        <!-- Email -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Email</label>
                                <input type="email" name="email" value="${participant.email}"
                                       class="form-control form-control-lg"
                                       pattern="^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$"
                                       title="exemple@domaine.com"
                                       required>
                                <div class="invalid-feedback">
                                    Format email invalide (ex: exemple@domaine.com)
                                </div>
                            </div>
                        </div>

                        <!-- Téléphone -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Téléphone</label>
                                <input type="tel" name="tel" value="${participant.tel}"
                                       class="form-control form-control-lg"
                                       pattern="[0-9]{8,15}"
                                       title="8 à 15 chiffres"
                                       required>
                                <div class="invalid-feedback">
                                    Numéro invalide (chiffres uniquement, 8-15 caractères)
                                </div>
                            </div>
                        </div>

                        <!-- Structure -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Structure</label>
                                <select name="structureId" class="form-select form-select-lg" required>
                                    <option value="">Sélectionnez une structure</option>
                                    <c:forEach items="${structures}" var="structure">
                                        <option value="${structure.id}" ${participant.structure.id == structure.id ? 'selected' : ''}>
                                                ${structure.libelle}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    Sélection obligatoire
                                </div>
                            </div>
                        </div>

                        <!-- Profil -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Profil</label>
                                <select name="profilId" class="form-select form-select-lg" required>
                                    <option value="">Sélectionnez un profil</option>
                                    <c:forEach items="${profils}" var="profil">
                                        <option value="${profil.id}" ${participant.profil.id == profil.id ? 'selected' : ''}>
                                                ${profil.libelle}
                                        </option>
                                    </c:forEach>
                                </select>
                                <div class="invalid-feedback">
                                    Sélection obligatoire
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-3 mt-4">
                        <a href="${pageContext.request.contextPath}/participants" class="btn btn-secondary">
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

<footer class="bg-dark text-white">
    <div class="container text-center py-3">
        <img src="https://cdn-icons-png.flaticon.com/512/1974/1974346.png" alt="Logo" width="40" class="mb-2">
        <p class="mb-0">SkillForge &copy; 2025 | Tous droits réservés</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Validation en temps réel
    document.querySelectorAll('input, select').forEach(element => {
        const validateField = () => {
            element.classList.remove('is-valid', 'is-invalid');

            if (element.checkValidity()) {
                element.classList.add('is-valid');
            } else {
                element.classList.add('is-invalid');
            }
        };

        // Événements de saisie
        element.addEventListener('input', validateField);
        element.addEventListener('change', validateField);
    });

    // Gestion de la soumission
    document.querySelector('form').addEventListener('submit', function(event) {
        this.classList.add('was-validated');

        if (!this.checkValidity()) {
            event.preventDefault();
            event.stopPropagation();
        }
    });

    // Initialisation de l'animation
    window.addEventListener("load", function() {
        document.querySelectorAll('.fade-in').forEach(el => {
            el.style.opacity = 1;
            el.style.transform = 'translateY(0)';
        });
    });
</script>
</body>
</html>