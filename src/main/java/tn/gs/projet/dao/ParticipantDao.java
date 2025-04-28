package tn.gs.projet.dao;


import jakarta.persistence.*;
import tn.gs.projet.model.Participant;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ParticipantDao {
    public EntityManager em;

    public ParticipantDao(EntityManager em) {
        this.em = em;
    }

    public ParticipantDao() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("trainingPU");
        em = emf.createEntityManager();
    }

    public void saveOrUpdate(Participant participant) {
        em.getTransaction().begin();
        if (participant.getId() == null) em.persist(participant);
        else em.merge(participant);
        em.getTransaction().commit();
    }

    public List<Participant> findAll() {
        return em.createQuery("SELECT p FROM Participant p", Participant.class).getResultList();
    }

    public Participant findById(Long id) {
        return em.find(Participant.class, id);
    }

    public void delete(Long id) {
        em.getTransaction().begin();
        Participant participant = em.find(Participant.class, id);
        if (participant != null) em.remove(participant);
        em.getTransaction().commit();
    }
    public Map<String, Long> getParticipantsCountByProfil() {
        return em.createQuery(
                        "SELECT p.libelle, COUNT(part) FROM Participant part JOIN part.profil p GROUP BY p.libelle", Object[].class)
                .getResultStream()
                .collect(Collectors.toMap(
                        o -> (String) o[0],
                        o -> (Long) o[1]
                ));
    }

}
