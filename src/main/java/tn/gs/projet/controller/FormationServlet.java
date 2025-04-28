package tn.gs.projet.controller;


import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import tn.gs.projet.dao.*;
import tn.gs.projet.model.*;
import java.io.IOException;
import java.util.Date;

@WebServlet("/formations")
public class FormationServlet extends HttpServlet {
    private FormationDao formationDao;
    private DomaineDao domaineDao;
    private ParticipantDao participantDao;


    @Override
    public void init() {
        formationDao = new FormationDao();
        domaineDao = new DomaineDao();
        participantDao = new ParticipantDao();
    }
    private EntityManager getEntityManager(HttpServletRequest request) {
        return (EntityManager) request.getAttribute("entityManager");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupérer l'EntityManager de la requête
        EntityManager entityManager = getEntityManager(request);

        // Initialiser les DAOs avec cet EntityManager
        formationDao = new FormationDao(entityManager);
        domaineDao = new DomaineDao(entityManager);
        participantDao = new ParticipantDao(entityManager);
        String action = request.getParameter("action") == null ? "list" : request.getParameter("action");
        try {
            switch (action) {
                case "new":
                    showNewForm(request, response);
                    break;
                case "add":
                    addEditFormation(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteFormation(request, response);
                case "deletePlanification":
                    deletePlanification(request, response);
                    return;
                default:
                    listFormations(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listFormations(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("formations", formationDao.findAll());
        request.getRequestDispatcher("/formations.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("domaines", domaineDao.findAll());
        request.setAttribute("participants", participantDao.findAll());
        request.getRequestDispatcher("/addFormation.jsp").forward(request, response);
    }

    private void addEditFormation(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        EntityManager entityManager = getEntityManager(request);
        EntityTransaction transaction = entityManager.getTransaction();

        try {
            transaction.begin();

            // Créer ou récupérer la formation
            Formation formation;
            String id = request.getParameter("id");
            if (id != null && !id.isEmpty()) {
                formation = formationDao.em.find(Formation.class, Long.parseLong(id));
            } else {
                formation = new Formation();

                formation.setTitre(request.getParameter("titre"));
                formation.setAnnee(Integer.parseInt(request.getParameter("annee")));
                formation.setDuree(Integer.parseInt(request.getParameter("duree")));
                formation.setBudget(Double.parseDouble(request.getParameter("budget")));
                formation.setDomaine(formationDao.em.find(Domaine.class, Long.parseLong(request.getParameter("domaineId"))));
                entityManager.persist(formation); // Génère l'ID
                entityManager.flush(); // Force la génération immédiate
            }

            // Gérer les participants
            String[] participantsIds = request.getParameterValues("participantId");
            if (participantsIds != null) {
                for (String participantId : participantsIds) {
                    Participant participant = entityManager.getReference(Participant.class, Long.parseLong(participantId));
                    FormationParticipant fp = new FormationParticipant();
                    fp.setFormation(formation);
                    fp.setParticipant(participant);
                    fp.setDateInscription(new Date());
                    fp.setId(new FormationParticipantId(formation.getId(), participant.getId()));
                    entityManager.persist(fp); // Persister explicitement
                }
            }

            transaction.commit();
        } catch (Exception e) {
            if (transaction.isActive()) transaction.rollback();
            throw new ServletException(e);
        }

        response.sendRedirect("formations?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        Formation formation = formationDao.findById(id);
        request.setAttribute("formation", formation);
        request.setAttribute("domaines", domaineDao.findAll());
        request.setAttribute("participants", participantDao.findAll());
        request.getRequestDispatcher("/addFormation.jsp").forward(request, response);
    }

    private void deleteFormation(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        formationDao.delete(id);
        response.sendRedirect("formations?action=list");
    }

    private void deletePlanification(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Long id = Long.parseLong(request.getParameter("id"));
            formationDao.deletePlanification(id);
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/formationsPlanifiees");
            }
        } catch (NumberFormatException e) {
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/errorPage.jsp?message=ID invalide");
            }
        } catch (Exception e) {
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/errorPage.jsp?message=" + e.getMessage());
            }
        }
    }

}
