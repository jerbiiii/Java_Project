package tn.gs.projet.controller;


import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityNotFoundException;
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

    private void addEditFormation(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        EntityManager entityManager = getEntityManager(request);
        EntityTransaction transaction = entityManager.getTransaction();
        HttpSession session = request.getSession();

        try {
            transaction.begin();

            // 1. CRÉATION OU RÉCUPÉRATION DE LA FORMATION
            Formation formation;
            String idParam = request.getParameter("id");

            if (idParam != null && !idParam.isEmpty()) {
                // MODE ÉDITION - Récupérer la formation existante
                Long id = Long.parseLong(idParam);
                formation = entityManager.find(Formation.class, id);

                if (formation == null) {
                    throw new ServletException("Formation introuvable avec l'ID: " + id);
                }

                // 2. MISE À JOUR DES PROPRIÉTÉS
                formation.setTitre(request.getParameter("titre"));
                formation.setAnnee(Integer.parseInt(request.getParameter("annee")));
                formation.setDuree(Integer.parseInt(request.getParameter("duree")));
                formation.setBudget(Double.parseDouble(request.getParameter("budget")));

                // Mise à jour du domaine
                Long domaineId = Long.parseLong(request.getParameter("domaineId"));
                Domaine domaine = entityManager.find(Domaine.class, domaineId);
                formation.setDomaine(domaine);

                // 3. SUPPRESSION DES ANCIENS PARTICIPANTS
                entityManager.createQuery("DELETE FROM FormationParticipant fp WHERE fp.formation = :formation")
                        .setParameter("formation", formation)
                        .executeUpdate();

            } else {
                // MODE CRÉATION - Nouvelle formation
                formation = new Formation();
                formation.setTitre(request.getParameter("titre"));
                formation.setAnnee(Integer.parseInt(request.getParameter("annee")));
                formation.setDuree(Integer.parseInt(request.getParameter("duree")));
                formation.setBudget(Double.parseDouble(request.getParameter("budget")));

                // Associer le domaine
                Long domaineId = Long.parseLong(request.getParameter("domaineId"));
                Domaine domaine = entityManager.find(Domaine.class, domaineId);
                formation.setDomaine(domaine);

                entityManager.persist(formation);
                entityManager.flush(); // Force la génération de l'ID
            }

            // 4. GESTION DES NOUVEAUX PARTICIPANTS
            String[] participantsIds = request.getParameterValues("participantId");
            if (participantsIds != null && participantsIds.length > 0) {
                for (String participantId : participantsIds) {
                    Participant participant = entityManager.find(Participant.class, Long.parseLong(participantId));

                    // Créer la nouvelle association
                    FormationParticipant fp = new FormationParticipant();
                    fp.setFormation(formation);
                    fp.setParticipant(participant);
                    fp.setDateInscription(new Date());
                    fp.setId(new FormationParticipantId(formation.getId(), participant.getId()));

                    entityManager.persist(fp);
                }
            }

            transaction.commit();

            // Message de succès différencié
            if (idParam != null) {
                session.setAttribute("warningMessage", "Formation modifiée avec succès !");
            } else {
                session.setAttribute("successMessage", "Formation ajoutée avec succès !");
            }

        } catch (NumberFormatException e) {
            if (transaction.isActive()) transaction.rollback();
            throw new ServletException("Format de données invalide: " + e.getMessage(), e);
        } catch (EntityNotFoundException e) {
            if (transaction.isActive()) transaction.rollback();
            throw new ServletException("Entité introuvable: " + e.getMessage(), e);
        } catch (Exception e) {
            if (transaction.isActive()) transaction.rollback();
            throw new ServletException("Erreur lors de l'opération: " + e.getMessage(), e);
        } finally {
            if (entityManager.isOpen()) {
                entityManager.close();
            }
        }

        response.sendRedirect(request.getContextPath() + "/formations?action=list");
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
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", "Formation supprimée avec succès !");
    }

    private void deletePlanification(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

            Long id = Long.parseLong(request.getParameter("id"));
            formationDao.deletePlanification(id);
            if (!response.isCommitted()) {
                response.sendRedirect(request.getContextPath() + "/formationsPlanifiees");
            }

    }

}
