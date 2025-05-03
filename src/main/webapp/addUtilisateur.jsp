<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Utilisateur</title>
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
            max-width: 600px;
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
        /* Loader Overlay amélioré */
        .loader-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(8px);
            z-index: 9999;
            display: none;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            transition: opacity 0.5s cubic-bezier(0.4, 0, 0.2, 1);
        }

        /* Loader 1 - Particules quantiques */
        .quantum-loader {
            position: relative;
            width: 100px;
            height: 100px;
        }

        .particle {
            position: absolute;
            width: 15px;
            height: 15px;
            border-radius: 50%;
            background: var(--secondary-color);
            animation: quantum 2s infinite cubic-bezier(0.4, 0, 0.2, 1);
        }

        .particle:nth-child(1) {
            animation-delay: 0s;
            background: var(--success-color);
        }
        .particle:nth-child(2) {
            animation-delay: 0.2s;
            background: var(--primary-color);
        }
        .particle:nth-child(3) {
            animation-delay: 0.4s;
            background: var(--secondary-color);
        }

        @keyframes quantum {
            0% { transform: rotate(0deg) translateX(40px) rotate(0deg); }
            100% { transform: rotate(360deg) translateX(40px) rotate(-360deg); }
        }

        /* Loader 2 - Vague dynamique */
        .wave-loader {
            display: flex;
            gap: 8px;
            height: 50px;
        }

        .bar {
            width: 12px;
            height: 30px;
            background: var(--primary-color);
            animation: wave 1.2s ease-in-out infinite;
            border-radius: 4px;
        }

        .bar:nth-child(2) { animation-delay: 0.2s; }
        .bar:nth-child(3) { animation-delay: 0.4s; }

        @keyframes wave {
            0%, 100% { height: 30px; }
            50% { height: 60px; background: var(--secondary-color); }
        }

        /* Loader 3 - Effet holographique */
        .hologram-loader {
            width: 80px;
            height: 80px;
            position: relative;
        }

        .hologram {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: linear-gradient(45deg,
            var(--secondary-color),
            var(--success-color),
            var(--primary-color));
            animation: hologram 2s infinite alternate;
            box-shadow: 0 0 20px rgba(52, 152, 219, 0.3);
        }

        @keyframes hologram {
            0% {
                transform: scale(0.9);
                opacity: 0.8;
            }
            100% {
                transform: scale(1.1);
                opacity: 1;
            }
        }

        .loader-text {
            margin-top: 25px;
            font-size: 1.2em;
            color: var(--primary-color);
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            background: linear-gradient(45deg, #2c3e50, #3498db);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .hidden { display: none; }

    </style>
</head>
<body>
<div id="loader-overlay" class="loader-overlay">
    <!-- Loader 1 - Particules tournantes -->
    <div class="loader-1 hidden">
        <div class="quantum-loader">
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
        </div>
        <div class="loader-text">Création de compte...</div>
    </div>


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
                    <i class="fas fa-user-edit me-2"></i>
                    ${not empty utilisateur ? 'Modifier' : 'Ajouter'} Utilisateur
                </h3>
            </div>
            <div class="card-body p-4">
                <form action="utilisateurs" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="action" value="add">
                    <c:if test="${not empty utilisateur}">
                        <input type="hidden" name="id" value="${utilisateur.id}">
                    </c:if>

                    <!-- Login avec validation renforcée -->
                    <div class="mb-4">
                        <label for="login" class="form-label fw-bold">Login</label>
                        <input type="text" id="login" name="login" value="${utilisateur.login}"
                               class="form-control form-control-lg"
                               pattern="^[A-Za-z][A-Za-z0-9_]{3,19}$"
                               title="4-20 caractères, commence par une lettre (a-z, A-Z), chiffres et _ autorisés"
                               required>
                        <div class="invalid-feedback">
                            Format invalide !<br>
                            - Doit commencer par une lettre<br>
                            - 4 à 20 caractères<br>
                            - Chiffres et underscores (_) uniquement
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label fw-bold">Mot de passe</label>
                        <input type="password" id="password" name="password"
                               class="form-control form-control-lg" required
                               pattern="(?=.*[A-Z])(?=.*\d).{8,}"
                               title="Au moins 8 caractères, dont une majuscule et un chiffre">
                        <div class="invalid-feedback">
                            Le mot de passe doit comporter au moins 8 caractères, dont une majuscule et un chiffre.
                        </div>
                    </div>

                    <div class="mb-4">
                        <label for="roleId" class="form-label fw-bold">Rôle</label>
                        <select id="roleId" name="roleId" class="form-select form-select-lg" required>
                            <option value="" disabled ${empty utilisateur.role.id ? 'selected' : ''}>Choisissez un rôle</option>
                            <c:forEach items="${roles}" var="role">
                                <option value="${role.id}" ${utilisateur.role.id == role.id ? 'selected' : ''}>
                                    ${role.nom}
                                </option>
                            </c:forEach>
                        </select>
                        <div class="invalid-feedback">
                            Veuillez sélectionner un rôle.
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-3">
                        <a href="${pageContext.request.contextPath}/utilisateurs"
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

    window.addEventListener("load", function() {
        document.querySelectorAll('.fade-in').forEach(el => {
            el.style.opacity = 1;
            el.style.transform = 'translateY(0)';
        });
    });
    document.querySelector('form').addEventListener('submit', function(e) {
        const loaders = document.querySelectorAll('#loader-overlay > div');
        const randomLoader = Math.floor(Math.random() * loaders.length);

        document.getElementById('loader-overlay').style.display = 'flex';
        loaders.forEach(loader => loader.classList.add('hidden'));
        loaders[randomLoader].classList.remove('hidden');
    });

    window.addEventListener('load', function() {
        document.getElementById('loader-overlay').style.display = 'none';
    });
    // Gestion des loaders
    document.querySelector('form').addEventListener('submit', function(e) {
        const loaders = document.querySelectorAll('#loader-overlay > div');
        const randomLoader = Math.floor(Math.random() * loaders.length);

        document.getElementById('loader-overlay').style.display = 'flex';
        loaders.forEach(loader => loader.classList.add('hidden'));
        loaders[randomLoader].classList.remove('hidden');
    });

    window.addEventListener('load', function() {
        document.getElementById('loader-overlay').style.display = 'none';
    });
</script>
</body>
</html>
