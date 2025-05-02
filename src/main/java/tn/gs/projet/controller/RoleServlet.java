package tn.gs.projet.controller;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import tn.gs.projet.dao.RoleDao;
import tn.gs.projet.model.Role;
import java.io.IOException;

@WebServlet("/roles")
public class RoleServlet extends HttpServlet {
    private RoleDao roleDao;

    @Override
    public void init() {
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
                    addEditRole(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteRole(request, response);
                    break;
                default:
                    listRoles(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listRoles(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("roles", roleDao.findAll());
        request.getRequestDispatcher("/roles.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("role", new Role());
        request.getRequestDispatcher("/addRole.jsp").forward(request, response);
    }

    private void addEditRole(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Role role = new Role();
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            role = roleDao.findById(Long.parseLong(id));
        }
        role.setNom(request.getParameter("nom"));
        roleDao.saveOrUpdate(role);
        HttpSession session = request.getSession();
        if (id == null || id.isEmpty()) {
            session.setAttribute("successMessage", "Rôle ajouté avec succès !");
        } else {
            session.setAttribute("warningMessage", "Rôle modifié avec succès !");
        }
        response.sendRedirect("roles?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            Role role = roleDao.findById(id); // Récupère un objet Role
            request.setAttribute("role", role);
            request.getRequestDispatcher("/addRole.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Erreur lors de l'édition du rôle", e);
        }

    }

    private void deleteRole(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        roleDao.delete(id);
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", "Rôle supprimé avec succès !");
        response.sendRedirect("roles?action=list");
    }
}
