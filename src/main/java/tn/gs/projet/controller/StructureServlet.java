package tn.gs.projet.controller;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import tn.gs.projet.dao.StructureDao;
import tn.gs.projet.model.Structure;
import java.io.IOException;

@WebServlet("/structures")
public class StructureServlet extends HttpServlet {
    private StructureDao structureDao;

    @Override
    public void init() {
        structureDao = new StructureDao();
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
                    addEditStructure(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteStructure(request, response);
                    break;
                default:
                    listStructures(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listStructures(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("structures", structureDao.findAll());
        request.getRequestDispatcher("/structures.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/addStructure.jsp").forward(request, response);
    }

    private void addEditStructure(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Structure structure = new Structure();
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            structure = structureDao.findById(Long.parseLong(id));
        }
        structure.setLibelle(request.getParameter("libelle"));
        structureDao.saveOrUpdate(structure);
        response.sendRedirect("structures?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        request.setAttribute("structure", structureDao.findById(id));
        request.getRequestDispatcher("/addStructure.jsp").forward(request, response);
    }

    private void deleteStructure(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        structureDao.delete(id);
        response.sendRedirect("structures?action=list");
    }
}
