package tn.gs.projet.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        // Désactiver le cache pour TOUTES les pages
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String path = request.getRequestURI().substring(request.getContextPath().length());

        // Autoriser uniquement les ressources publiques
        if (path.startsWith("/login") || path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;

        // Rediriger vers le dashboard si déjà connecté
        if (path.startsWith("/login")) {
            if (role != null) {
                switch (role) {
                    case "administrateur":
                        response.sendRedirect(request.getContextPath() + "/adminDashboard.jsp");
                        break;
                    case "responsable":
                        response.sendRedirect(request.getContextPath() + "/home");
                        break;
                    case "simple_utilisateur":
                        response.sendRedirect(request.getContextPath() + "/utilisateurDashboard.jsp");
                        break;
                }
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // Bloquer l'accès non authentifié
        if (role == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}