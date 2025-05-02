package tn.gs.projet.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import tn.gs.projet.dao.EmployeurDao;
import tn.gs.projet.model.Employeur;
import java.io.IOException;

@WebServlet("/employeurs")
public class EmployeurServlet extends HttpServlet {
    private EmployeurDao employeurDao;

    @Override
    public void init() {
        employeurDao = new EmployeurDao();
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
                    addEditEmployeur(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteEmployeur(request, response);
                    break;
                default:
                    listEmployeurs(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listEmployeurs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("employeurs", employeurDao.findAll());
        request.getRequestDispatcher("/employeurs.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/addEmployeur.jsp").forward(request, response);
    }

    private void addEditEmployeur(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Employeur employeur = new Employeur();
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            employeur = employeurDao.findById(Long.parseLong(id));
        }
        employeur.setNomEmployeur(request.getParameter("nomEmployeur"));
        employeurDao.saveOrUpdate(employeur);
        HttpSession session = request.getSession();
        if (id == null || id.isEmpty()) {
            session.setAttribute("successMessage", "Employeur ajouté avec succès !");
        } else {
            session.setAttribute("warningMessage", "Employeur modifié avec succès !");
        }
        response.sendRedirect("employeurs?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        request.setAttribute("employeur", employeurDao.findById(id));
        request.getRequestDispatcher("/addEmployeur.jsp").forward(request, response);
    }

    private void deleteEmployeur(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        employeurDao.delete(id);
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", "Employeur supprimé avec succès !");
        response.sendRedirect("employeurs?action=list");
    }
}
