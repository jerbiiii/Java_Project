package tn.gs.projet.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tn.gs.projet.dao.FormationDao;


import java.io.IOException;
import java.util.Map;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private FormationDao formationDao = new FormationDao();


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Map<String, Long> formationsParAnnee = formationDao.getFormationsCountByYear();

        // Convertir en JSON
        Gson gson = new Gson();
        request.setAttribute("formationsParAnneeJSON", gson.toJson(formationsParAnnee));

        // Rediriger vers homeDashboard.jsp
        request.getRequestDispatcher("/homeDashboard.jsp").forward(request, response);
    }
}
