package tn.gs.projet.controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import tn.gs.projet.dao.*;
import tn.gs.projet.model.*;
import java.io.IOException;

@WebServlet("/participants")
public class ParticipantServlet extends HttpServlet {
    private ParticipantDao participantDao;
    private StructureDao structureDao;
    private ProfilDao profilDao;

    @Override
    public void init() {
        participantDao = new ParticipantDao();
        structureDao = new StructureDao();
        profilDao = new ProfilDao();
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
                    addEditParticipant(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteParticipant(request, response);
                    break;
                default:
                    listParticipants(request, response);
            }
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void listParticipants(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("participants", participantDao.findAll());
        request.getRequestDispatcher("/participants.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("structures", structureDao.findAll());
        request.setAttribute("profils", profilDao.findAll());
        request.getRequestDispatcher("/addParticipant.jsp").forward(request, response);
    }

    private void addEditParticipant(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Participant participant = new Participant();
        String id = request.getParameter("id");
        if (id != null && !id.isEmpty()) {
            participant = participantDao.findById(Long.parseLong(id));
        }
        participant.setNom(request.getParameter("nom"));
        participant.setPrenom(request.getParameter("prenom"));
        participant.setEmail(request.getParameter("email"));
        participant.setTel(Integer.parseInt(request.getParameter("tel")));
        participant.setStructure(structureDao.findById(Long.parseLong(request.getParameter("structureId"))));
        participant.setProfil(profilDao.findById(Long.parseLong(request.getParameter("profilId"))));
        participantDao.saveOrUpdate(participant);
        HttpSession session = request.getSession();
        if (id == null || id.isEmpty()) {
            session.setAttribute("successMessage", "Participant ajouté avec succès !");
        } else {
            session.setAttribute("warningMessage", "Participant modifié avec succès !");
        }
        response.sendRedirect("participants?action=list");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        request.setAttribute("participant", participantDao.findById(id));
        request.setAttribute("structures", structureDao.findAll());
        request.setAttribute("profils", profilDao.findAll());
        request.getRequestDispatcher("/addParticipant.jsp").forward(request, response);
    }

    private void deleteParticipant(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Long id = Long.parseLong(request.getParameter("id"));
        participantDao.delete(id);
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", "Participant supprimé avec succès !");
        response.sendRedirect("participants?action=list");
    }
}
