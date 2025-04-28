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

@WebServlet("/utilisateurDashboard")
public class UtilisateurDashboardServlet extends HttpServlet {
    private FormationDao formationDao = new FormationDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Formation> dernieresFormations = formationDao.findDernieresPlanifiees(5);
        request.setAttribute("dernieresFormations", dernieresFormations);
        request.getRequestDispatcher("/utilisateurDashboard.jsp").forward(request, response);
    }
}