<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Formateur</title>
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
            --error-color: #e74c3c;
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
        /* Loader Overlay */
        .loader-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            z-index: 9999;
            display: none;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        /* Loader 1 - Rotating Cubes */
        .cube-container {
            display: flex;
            gap: 12px;
        }

        .cube {
            width: 25px;
            height: 25px;
            background: var(--secondary-color);
            animation: cubeJump 1.2s infinite ease-in-out;
        }

        .cube:nth-child(2) {
            animation-delay: 0.2s;
            background: var(--success-color);
        }

        .cube:nth-child(3) {
            animation-delay: 0.4s;
            background: var(--primary-color);
        }

        @keyframes cubeJump {
            0%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-30px); }
        }

        /* Loader 2 - Bouncing Dots */
        .dot-flashing {
            position: relative;
            width: 10px;
            height: 10px;
            border-radius: 5px;
            background-color: var(--secondary-color);
            animation: dotFlashing 1s infinite linear alternate;
            animation-delay: 0.5s;
        }

        .dot-flashing::before, .dot-flashing::after {
            content: '';
            position: absolute;
            width: 10px;
            height: 10px;
            border-radius: 5px;
            background-color: var(--secondary-color);
            animation: dotFlashing 1s infinite alternate;
        }

        .dot-flashing::before {
            left: -15px;
            animation-delay: 0s;
        }

        .dot-flashing::after {
            left: 15px;
            animation-delay: 1s;
        }

        @keyframes dotFlashing {
            0% { background-color: var(--secondary-color); }
            50%, 100% { background-color: rgba(52, 152, 219, 0.2); }
        }

        /* Loader 3 - Morphing Circle */
        .morph-circle {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: var(--success-color);
            animation: morph 2s infinite ease-in-out;
        }

        @keyframes morph {
            0%, 100% {
                border-radius: 50%;
                transform: scale(1) rotate(0deg);
            }
            50% {
                border-radius: 30%;
                transform: scale(1.2) rotate(180deg);
            }
        }

        .loader-text {
            margin-top: 20px;
            font-weight: 500;
            color: var(--primary-color);
            font-size: 1.1em;
        }

        .hidden { display: none; }
    </style>
</head>
<body>

<div id="loader-overlay" class="loader-overlay">
    <!-- Loader 1 - Rotating Cubes -->
    <div class="loader-1 hidden">
        <div class="cube-container">
            <div class="cube"></div>
            <div class="cube"></div>
            <div class="cube"></div>
        </div>
        <div class="loader-text">Enregistrement en cours</div>
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
                    <i class="fas fa-chalkboard-teacher me-2"></i>
                    ${not empty formateur ? 'Modifier' : 'Ajouter'} Formateur
                </h3>
            </div>
            <div class="card-body p-4">
                <form action="formateurs" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="action" value="add">
                    <c:if test="${not empty formateur}">
                        <input type="hidden" name="id" value="${formateur.id}">
                    </c:if>

                    <div class="row g-4">
                        <!-- Nom -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Nom</label>
                                <input type="text" name="nom" value="${formateur.nom}"
                                       class="form-control form-control-lg"
                                       pattern="[A-Za-zÀ-ÿ\s\-]{2,50}"
                                       title="2-50 caractères alphabétiques" required>
                                <div class="invalid-feedback">
                                    Le nom est requis (2-50 lettres)
                                </div>
                            </div>
                        </div>

                        <!-- Prénom -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Prénom</label>
                                <input type="text" name="prenom" value="${formateur.prenom}"
                                       class="form-control form-control-lg"
                                       pattern="[A-Za-zÀ-ÿ\s\-]{2,50}"
                                       title="2-50 caractères alphabétiques" required>
                                <div class="invalid-feedback">
                                    Le prénom est requis (2-50 lettres)
                                </div>
                            </div>
                        </div>

                        <!-- Email -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Email</label>
                                <input type="email" name="email" value="${formateur.email}"
                                       class="form-control form-control-lg"
                                       pattern="^[a-zA-Z0-9._%+-]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$"
                                       title="Format : nom@test.com"
                                       required>
                                <div class="invalid-feedback">
                                    Format email invalide (ex: exemple@test.com)
                                </div>
                            </div>
                        </div>

                        <!-- Téléphone -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Téléphone</label>
                                <input type="tel" name="tel" value="${formateur.tel}"
                                       class="form-control form-control-lg"
                                       pattern="[0-9]{8,20}"
                                       title="8-20 chiffres" required>
                                <div class="invalid-feedback">
                                    Numéro invalide (8-20 chiffres)
                                </div>
                            </div>
                        </div>

                        <!-- Type -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Type</label>
                                <select name="type" class="form-select form-select-lg" required>
                                    <option value="">Sélectionnez un type</option>
                                    <option value="interne" ${formateur.type == 'interne' ? 'selected' : ''}>Interne</option>
                                    <option value="externe" ${formateur.type == 'externe' ? 'selected' : ''}>Externe</option>
                                </select>
                                <div class="invalid-feedback">
                                    Sélection obligatoire
                                </div>
                            </div>
                        </div>

                        <!-- Employeur -->
                        <div class="col-md-6">
                            <div class="mb-4">
                                <label class="form-label fw-bold">Employeur</label>
                                <select name="employeurId" class="form-select form-select-lg" required>
                                    <option value="">Sélectionnez un employeur</option>
                                    <c:forEach items="${employeurs}" var="employeur">
                                        <option value="${employeur.id}" ${formateur.employeur.id == employeur.id ? 'selected' : ''}>
                                                ${employeur.nomEmployeur}
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
                        <a href="${pageContext.request.contextPath}/formateurs" class="btn btn-secondary">
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
</script>
</body>
</html>