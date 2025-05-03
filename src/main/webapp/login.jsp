<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<c:if test="${not empty sessionScope.role}">
  <c:choose>
    <c:when test="${sessionScope.role == 'administrateur'}">
      <c:redirect url="/adminDashboard.jsp" />
    </c:when>
    <c:when test="${sessionScope.role == 'responsable'}">
      <c:redirect url="/home" />
    </c:when>
    <c:when test="${sessionScope.role == 'simple_utilisateur'}">
      <c:redirect url="/utilisateurDashboard.jsp" />
    </c:when>
  </c:choose>
</c:if>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Connexion - SkillForge</title>
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
            justify-content: center;
        }

        .login-container {
            max-width: 500px;
            margin: 0 auto;
            padding: 2rem;
        }

        .login-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .card-header {
            background: var(--primary-color);
            color: white;
            padding: 1.5rem;
            text-align: center;
            border-radius: 16px 16px 0 0;
        }

        .card-body {
            padding: 2rem;
        }

        .btn {
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }

        .form-control-lg {
            padding: 0.75rem 1rem;
            font-size: 1.1rem;
        }

        .fade-in {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeInUp 0.6s ease forwards;
        }

        @keyframes fadeInUp {
            to { opacity: 1; transform: translateY(0); }
        }

        footer {
            margin-top: auto;
            background: var(--dark);
            color: white;
            padding: 1.5rem 0;
        }
        /* Nouveau design du loader */
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
            align-items: center;
            justify-content: center;
            flex-direction: column;
            transition: opacity 0.5s ease;
        }

        .modern-loader {
            position: relative;
            width: 200px;
            height: 200px;
        }

        .logo-pulse {
            position: absolute;
            width: 80px;
            height: 80px;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: pulse 2s infinite ease-in-out;
        }

        .logo-pulse img {
            width: 100%;
            height: 100%;
            object-fit: contain;
        }

        .spinner-track {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            border: 3px solid transparent;
            border-top-color: #2c3e50;
            border-bottom-color: #3498db;
            animation: rotate 1.5s linear infinite;
            position: relative;
        }

        .spinner-track::after {
            content: '';
            position: absolute;
            top: 10px;
            left: 10px;
            right: 10px;
            bottom: 10px;
            border-radius: 50%;
            border: 3px solid transparent;
            border-top-color: #27ae60;
            border-bottom-color: #e74c3c;
            animation: rotate 2s linear infinite reverse;
        }

        .loading-text {
            text-align: center;
            margin-top: 20px;
            font-size: 1.2em;
            color: #2c3e50;
            font-weight: 500;
        }

        .animated-dots::after {
            content: '.';
            animation: dots 1.5s steps(5, end) infinite;
        }

        @keyframes rotate {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @keyframes pulse {
            0% { transform: translate(-50%, -50%) scale(1); }
            50% { transform: translate(-50%, -50%) scale(1.1); }
            100% { transform: translate(-50%, -50%) scale(1); }
        }

        @keyframes dots {
            0%, 20% { content: '.'; }
            40% { content: '..'; }
            60% { content: '...'; }
            80%, 100% { content: ''; }
        }
    </style>
</head>
<body>

<div id="loader" class="loader-overlay">
    <div class="modern-loader">
        <div class="logo-pulse">
            <img src="https://cdn-icons-png.flaticon.com/512/1974/1974346.png" alt="Logo">
        </div>
        <div class="spinner-track"></div>
        <div class="loading-text">Authentification en cours<span class="animated-dots"></span></div>
    </div>
</div>

<div class="login-container fade-in">
    <div class="login-card">
        <div class="card-header">
            <img src="https://cdn-icons-png.flaticon.com/512/1974/1974346.png" alt="Logo" width="60" class="mb-3">
            <h2 class="mb-0">Connexion à SkillForge</h2>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger rounded-8 mb-4">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="mb-4">
                    <label class="form-label fw-bold">Identifiant</label>
                    <input type="text" name="login"
                           class="form-control form-control-lg"
                           placeholder="Saisissez votre identifiant"
                           required>
                </div>

                <div class="mb-4">
                    <label class="form-label fw-bold">Mot de passe</label>
                    <input type="password" name="password"
                           class="form-control form-control-lg"
                           placeholder="Saisissez votre mot de passe"
                           required>
                </div>

                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt me-2"></i>
                        Se connecter
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Footer -->
<footer class="bg-dark text-white">
    <div class="container text-center py-3">
        <img src="https://cdn-icons-png.flaticon.com/512/1974/1974346.png" alt="Logo" width="40" class="mb-2">
        <p class="mb-0">SkillForge &copy; 2025 | Tous droits réservés</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Afficher le loader lors de la soumission
    document.querySelector('form').addEventListener('submit', function() {
        document.getElementById('loader').style.display = 'flex';
    });

    // Cacher le loader si la page se recharge (en cas d'erreur)
    window.addEventListener('load', function() {
        document.getElementById('loader').style.display = 'none';
    });
</script>
</body>
</html>