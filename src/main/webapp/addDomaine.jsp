<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Domaine</title>
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
        /* Animations nature */
        .leaf-loader {
            display: flex;
            gap: 15px;
        }

        .leaf {
            width: 30px;
            height: 30px;
            background: var(--success-color);
            clip-path: polygon(50% 0%, 0% 100%, 100% 100%);
            animation: leafFloat 1.5s ease-in-out infinite;
        }

        @keyframes leafFloat {
            0%, 100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(15deg); }
        }

        .growing-tree {
            width: 50px;
            height: 0;
            background: var(--primary-color);
            animation: grow 2s ease-out forwards;
        }

        @keyframes grow {
            to { height: 80px; }
        }

        .water-drop {
            position: relative;
            width: 50px;
            height: 50px;
        }

        .ripple {
            width: 100%;
            height: 100%;
            border: 3px solid var(--secondary-color);
            border-radius: 50%;
            animation: ripple 1.5s infinite;
        }

        @keyframes ripple {
            to { transform: scale(2); opacity: 0; }
        }
        .loader-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(8px);
            z-index: 9999;
            display: none;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        .hidden {
            display: none;
        }
    </style>
</head>
<body>

<div id="loader-overlay" class="loader-overlay">
    <!-- Loader 1 - Feuilles tournantes -->
    <div class="loader-1 hidden">
        <div class="leaf-loader">
            <div class="leaf"></div>
            <div class="leaf"></div>
            <div class="leaf"></div>
        </div>
        <div class="loader-text">Enregistrement du domaine...</div>
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
                    <i class="fas fa-layer-group me-2"></i>
                    ${not empty domaine ? 'Modifier' : 'Ajouter'} Domaine
                </h3>
            </div>
            <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/domaines" method="post">
                    <input type="hidden" name="action" value="add">
                    <c:if test="${not empty domaine}">
                        <input type="hidden" name="id" value="${domaine.id}">
                    </c:if>

                    <div class="mb-4">
                        <label class="form-label fw-bold">Libellé</label>
                        <input type="text" name="libelle" value="${domaine.libelle}"
                               class="form-control form-control-lg" required>
                    </div>

                    <div class="d-flex justify-content-end gap-3">
                        <a href="${pageContext.request.contextPath}/domaines"
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

    // Afficher le loader
    const loaders = document.querySelectorAll('#loader-overlay > div');
    const randomLoader = Math.floor(Math.random() * loaders.length);
    document.getElementById('loader-overlay').style.display = 'flex';
    loaders.forEach(l => l.classList.add('hidden'));
    loaders[randomLoader].classList.remove('hidden');

    // Soumission AJAX
    const formData = new FormData(this);

    axios.post(this.action, formData)
        .then(response => {
            window.location.href = "${pageContext.request.contextPath}/domaines";
        })
        .catch(error => {
            alert("Erreur lors de l'enregistrement");
            document.getElementById('loader-overlay').style.display = 'none';
        });
    });

</script>
</body>
</html>