<style>
:root {
    --primary-color: #2c3e50;
    --secondary-color: #3498db;
    --success-color: #27ae60;
    --light-bg: #f8f9fa;
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
}

.table {
    box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    border-radius: 8px;
    overflow: hidden;
}

.card, .stat-card, .quick-action-card {
    border: none;
    border-radius: 12px !important;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    transition: transform 0.3s;
}

.card:hover, .stat-card:hover, .quick-action-card:hover {
    transform: translateY(-5px);
}

.btn {
    border-radius: 8px;
    padding: 8px 20px;
    font-weight: 500;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.table thead {
    background: var(--primary-color);
    color: white !important;
}

.chart-container {
    background: white;
    border-radius: 12px;
    padding: 20px;
    margin: 15px 0;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
}

.main-content {
    margin-top: 80px;
    flex: 1;
}

.alert {
    border-radius: 8px;
}
</style>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Erreur</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
  <div class="card shadow-lg">
    <div class="card-header bg-danger text-white">
      <h3 class="card-title"><i class="fas fa-exclamation-triangle me-2"></i>Erreur</h3>
    </div>
    <div class="card-body">
      <div class="alert alert-danger">
        <!-- Afficher le message d'erreur de manière sécurisée -->
        <c:choose>
          <c:when test="${not empty param.message}">
            <p class="mb-0"><c:out value="${param.message}" /></p>
          </c:when>
          <c:otherwise>
            <p class="mb-0">Une erreur inattendue s'est produite.</p>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- Bouton de retour dynamique -->
      <div class="text-center">
        <c:choose>
          <c:when test="${sessionScope.role == 'administrateur'}">
            <a href="${pageContext.request.contextPath}/adminDashboard.jsp"
               class="btn btn-primary">
              <i class="fas fa-home me-2"></i>Retour à l'accueil
            </a>
          </c:when>
          <c:when test="${sessionScope.role == 'responsable'}">
            <a href="${pageContext.request.contextPath}/home"
               class="btn btn-primary">
              <i class="fas fa-home me-2"></i>Retour à l'accueil
            </a>
          </c:when>
          <c:otherwise>
            <a href="${pageContext.request.contextPath}/login"
               class="btn btn-primary">
              <i class="fas fa-sign-in-alt me-2"></i>Se connecter
            </a>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>