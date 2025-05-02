package tn.gs.projet.controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
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
        HttpSession session = request.getSession();

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


            Long excludeId = formation != null ? formation.getId() : -1L;

            // Vérification des conflits
            List<Formation> conflicts = formationDao.findConflictingFormations(
                    formateurId,
                    dateDebut,
                    dateFin,
                    excludeId
            );

            if(!conflicts.isEmpty()) {
                Formation conflict = conflicts.get(0);
                String message = String.format(
                        "Le formateur est déjà en formation du %s au %s",
                        conflict.getDateDebut(),
                        conflict.getDateFin()
                );
                session.setAttribute("errorMessage", message);
                response.sendRedirect(request.getContextPath() + "/formationsPlanifiees");
                return;
            }

            // Mise à jour de la formation
            formation.setDateDebut(dateDebut);
            formation.setDateFin(dateFin);
            formation.setLieu(lieu);
            formation.setFormateur(formateur);

            formationDao.saveOrUpdate(formation);
            transaction.commit();


            session.setAttribute("successMessage", "Planification réussie !");
            response.sendRedirect(request.getContextPath() + "/formationsPlanifiees");

        } catch (Exception e) {
            if (transaction.isActive()) transaction.rollback();
            session.setAttribute("errorMessage", "Erreur technique : " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/planification");
        }
    }
}