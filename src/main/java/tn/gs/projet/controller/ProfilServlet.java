package tn.gs.projet.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import tn.gs.projet.dao.ProfilDao;
import tn.gs.projet.model.Profil;
import java.io.IOException;

@WebServlet("/profils")
public class ProfilServlet extends HttpServlet {
    private ProfilDao profilDao;

    @Override
    public void init() {
        profilDao = new ProfilDao();
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
                    addEditProfil(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteProfil(request, response);
                    break;
                default:
                    listProfils(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listProfils(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("profils", profilDao.findAll());
        request.getRequestDispatcher("/profils.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/addProfil.jsp").forward(request, response);
    }

    private void addEditProfil(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Profil profil = new Profil();
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            profil = profilDao.findById(Long.parseLong(id));
        }
        profil.setLibelle(request.getParameter("libelle"));
        profilDao.saveOrUpdate(profil);
        HttpSession session = request.getSession();
        if (id == null || id.isEmpty()) {
            session.setAttribute("successMessage", "Profil ajouté avec succès !");
        } else {
            session.setAttribute("warningMessage", "Profil modifié avec succès !");
        }
        response.sendRedirect("profils?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        request.setAttribute("profil", profilDao.findById(id));
        request.getRequestDispatcher("/addProfil.jsp").forward(request, response);
    }

    private void deleteProfil(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        profilDao.delete(id);
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", "Profil supprimé avec succès !");
        response.sendRedirect("profils?action=list");
    }
}
