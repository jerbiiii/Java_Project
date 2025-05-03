package tn.gs.projet.controller;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import tn.gs.projet.dao.*;
import tn.gs.projet.model.*;
import java.io.IOException;

@WebServlet("/formateurs")
public class FormateurServlet extends HttpServlet {
    private FormateurDao formateurDao;
    private EmployeurDao employeurDao;

    @Override
    public void init() {
        formateurDao = new FormateurDao();
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
                    addEditFormateur(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteFormateur(request, response);
                    break;
                default:
                    listFormateurs(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listFormateurs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("formateurs", formateurDao.findAll());
        request.getRequestDispatcher("/formateurs.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("employeurs", employeurDao.findAll());
        request.getRequestDispatcher("/addFormateur.jsp").forward(request, response);
    }

    private void addEditFormateur(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Formateur formateur = new Formateur();
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            formateur = formateurDao.findById(Long.parseLong(id));
        }
        formateur.setNom(request.getParameter("nom"));
        formateur.setPrenom(request.getParameter("prenom"));
        formateur.setEmail(request.getParameter("email"));
        formateur.setTel(Long.parseLong(request.getParameter("tel").replaceAll("[^0-9]", "")));
        formateur.setType(request.getParameter("type"));
        formateur.setEmployeur(employeurDao.findById(Long.parseLong(request.getParameter("employeurId"))));
        formateurDao.saveOrUpdate(formateur);
        HttpSession session = request.getSession();
        if (id == null || id.isEmpty()) {
            session.setAttribute("successMessage", "Formateur ajouté avec succès !");
        } else {
            session.setAttribute("warningMessage", "Formateur modifié avec succès !");
        }
        response.sendRedirect("formateurs?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        request.setAttribute("formateur", formateurDao.findById(id));
        request.setAttribute("employeurs", employeurDao.findAll());
        request.getRequestDispatcher("/addFormateur.jsp").forward(request, response);
    }

    private void deleteFormateur(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        formateurDao.delete(id);

        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", "Formateur supprimé avec succès !");
        response.sendRedirect("formateurs?action=list");
    }
}
