package tn.gs.projet.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tn.gs.projet.dao.FormationDao;
import tn.gs.projet.model.Formation;

import java.io.IOException;
import java.util.List;

@WebServlet("/formationsPlanifiees")
public class FormationsPlanifieesServlet extends HttpServlet {
    private FormationDao formationDao = new FormationDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Formation> formations = formationDao.findPlanifiees();
        request.setAttribute("formationsPlanifiees", formations);
        request.getRequestDispatcher("/formationsPlanifiees.jsp").forward(request, response);
    }
}
