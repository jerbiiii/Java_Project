package tn.gs.projet.controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import tn.gs.projet.dao.FormateurDao;
import tn.gs.projet.dao.FormationDao;
import tn.gs.projet.model.Formateur;
import tn.gs.projet.model.Formation;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;


@WebServlet("/planification")
public class PlanificationServlet extends HttpServlet {
    private FormationDao formationDao;
    private FormateurDao formateurDao;

    @Override
    public void init() {
        formationDao = new FormationDao();
        formateurDao = new FormateurDao();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Formation> formationsNonPlanifiees = formationDao.findNonPlanifiees();
        List<Formateur> formateurs = formateurDao.findAll();

        request.setAttribute("formationsNonPlanifiees", formationsNonPlanifiees);
        request.setAttribute("formateurs", formateurs);
        request.getRequestDispatcher("/planification.jsp").forward(request, response);
    }



    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        EntityManager em = (EntityManager) request.getAttribute("entityManager");
        EntityTransaction transaction = em.getTransaction();

        try {
            transaction.begin();

            // Récupération des paramètres
            Long formationId = Long.parseLong(request.getParameter("formationId"));
            Long formateurId = Long.parseLong(request.getParameter("formateurId"));
            LocalDate dateDebut = LocalDate.parse(request.getParameter("dateDebut"));
            LocalDate dateFin = LocalDate.parse(request.getParameter("dateFin"));
            String lieu = request.getParameter("lieu");

            // Validation métier
            Formation formation = formationDao.findById(formationId);
            Formateur formateur = formateurDao.findById(formateurId);

            if(!formationDao.isFormateurDisponible(formateurId, dateDebut, dateFin)) {
                request.setAttribute("erreur", "Le formateur est indisponible pour cette période");
                doGet(request, response);
                return;
            }

            // Mise à jour de la formation
            formation.setDateDebut(dateDebut);
            formation.setDateFin(dateFin);
            formation.setLieu(lieu);
            formation.setFormateur(formateur);

            formationDao.saveOrUpdate(formation);
            transaction.commit();

            response.sendRedirect(request.getContextPath() + "/formationsPlanifiees");


        } catch (Exception e) {
            if (transaction.isActive()) transaction.rollback();
            request.setAttribute("erreur", "Erreur lors de la planification : " + e.getMessage());
            doGet(request, response);
        }
    }
}