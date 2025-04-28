package tn.gs.projet.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import tn.gs.projet.dao.DomaineDao;
import tn.gs.projet.model.Domaine;
import java.io.IOException;

@WebServlet("/domaines")
public class DomaineServlet extends HttpServlet {
    private DomaineDao domaineDao;

    @Override
    public void init() {
        domaineDao = new DomaineDao();
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
                    addEditDomaine(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteDomaine(request, response);
                    break;
                default:
                    listDomaines(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listDomaines(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("domaines", domaineDao.findAll());
        request.getRequestDispatcher("/domaines.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/addDomaine.jsp").forward(request, response);
    }

    private void addEditDomaine(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Domaine domaine = new Domaine();
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            domaine = domaineDao.findById(Long.parseLong(id));
        }
        domaine.setLibelle(request.getParameter("libelle"));
        domaineDao.saveOrUpdate(domaine);
        response.sendRedirect("domaines?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        request.setAttribute("domaine", domaineDao.findById(id));
        request.getRequestDispatcher("/addDomaine.jsp").forward(request, response);
    }

    private void deleteDomaine(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        domaineDao.delete(id);
        response.sendRedirect("domaines?action=list");
    }
}
