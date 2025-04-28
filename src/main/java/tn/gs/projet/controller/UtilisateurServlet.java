package tn.gs.projet.controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.PersistenceContext;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import tn.gs.projet.dao.UtilisateurDao;
import tn.gs.projet.dao.RoleDao;
import tn.gs.projet.model.Utilisateur;
import java.io.IOException;

@WebServlet(name = "UtilisateurServlet", urlPatterns = "/utilisateurs")
public class UtilisateurServlet extends HttpServlet {
    private UtilisateurDao utilisateurDao;
    private RoleDao roleDao;


    @Override
    public void init() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("trainingPU");
        utilisateurDao = new UtilisateurDao();
        roleDao = new RoleDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action") == null ? "list" : request.getParameter("action");
        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "add":
                    addEditUtilisateur(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteUtilisateur(request, response);
                    break;
                default:
                    listUtilisateurs(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listUtilisateurs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("utilisateurs", utilisateurDao.findAll());
        request.getRequestDispatcher("/utilisateurs.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("roles", roleDao.findAll());
        request.getRequestDispatcher("/addUtilisateur.jsp").forward(request, response);
    }

    private void addEditUtilisateur(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Utilisateur utilisateur = new Utilisateur();
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            utilisateur = utilisateurDao.findById(Long.parseLong(id));
        }
        utilisateur.setLogin(request.getParameter("login"));
        utilisateur.setPassword(request.getParameter("password"));
        utilisateur.setRole(roleDao.findById(Long.parseLong(request.getParameter("roleId"))));
        utilisateurDao.saveOrUpdate(utilisateur);
        response.sendRedirect("utilisateurs?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        request.setAttribute("utilisateur", utilisateurDao.findById(id));
        request.setAttribute("roles", roleDao.findAll());
        request.getRequestDispatcher("/addUtilisateur.jsp").forward(request, response);
    }

    private void deleteUtilisateur(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        utilisateurDao.delete(id);
        response.sendRedirect("utilisateurs?action=list");
    }
}