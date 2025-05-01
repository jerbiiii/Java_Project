package tn.gs.projet.controller;

import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tn.gs.projet.dao.FormationDao;
import tn.gs.projet.dao.ParticipantDao;
import java.io.IOException;
import java.util.Map;


@WebServlet("/stats")
public class StatsServlet extends HttpServlet {
    private FormationDao formationDao = new FormationDao();
    private ParticipantDao participantDao = new ParticipantDao();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {


        // Récupérer les données pour les graphiques
        Map<String, Long> formationsParDomaine = formationDao.getFormationsCountByDomain();
        Map<String, Long> participantsParProfil = participantDao.getParticipantsCountByProfil();

        Map<String, Double> budgetParDomaine = formationDao.getBudgetByDomain();

        Map<String, Long> participantsParStructure = participantDao.getParticipantsCountByStructure();


        // Convertir en JSON
        Gson gson = new Gson();

        request.setAttribute("formationsParDomaineJSON", gson.toJson(formationsParDomaine));
        request.setAttribute("participantsParProfilJSON", gson.toJson(participantsParProfil));

        request.setAttribute("budgetParDomaineJSON", gson.toJson(budgetParDomaine));
        request.setAttribute("participantsParStructureJSON", gson.toJson(participantsParStructure));



        request.getRequestDispatcher("/stats.jsp").forward(request, response);

    }
}
