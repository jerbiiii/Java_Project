package tn.gs.projet.controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import tn.gs.projet.dao.UtilisateurDao;
import tn.gs.projet.model.Utilisateur;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UtilisateurDao utilisateurDao = new UtilisateurDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String login = request.getParameter("login");
        String password = request.getParameter("password");

        Utilisateur user = utilisateurDao.findByLogin(login);

        if (user != null && user.getPassword().equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("login", login);
            session.setAttribute("user", user);
            String role = user.getRoleName();
            session.setAttribute("role", role);

            // Redirection selon le rôle
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
                default:
                    request.setAttribute("error", "Rôle non reconnu !");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Login ou mot de passe incorrect");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}