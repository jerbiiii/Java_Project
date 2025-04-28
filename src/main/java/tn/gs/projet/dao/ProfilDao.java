package tn.gs.projet.dao;


import jakarta.persistence.*;
import jakarta.transaction.Transactional;
import tn.gs.projet.model.Profil;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ProfilDao {
    private EntityManager em;

    public ProfilDao() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("trainingPU");
        em = emf.createEntityManager();
    }

    public void saveOrUpdate(Profil profil) {
        em.getTransaction().begin();
        if (profil.getId() == null) em.persist(profil);
        else em.merge(profil);
        em.getTransaction().commit();
    }

    public List<Profil> findAll() {
        return em.createQuery("SELECT p FROM Profil p", Profil.class).getResultList();
    }

    public Profil findById(Long id) {
        return em.find(Profil.class, id);
    }

    public void delete(Long id) {
        em.getTransaction().begin();
        Profil profil = em.find(Profil.class, id);
        if (profil != null) em.remove(profil);
        em.getTransaction().commit();
    }

    @Transactional
    public Map<String, Long> getParticipantsCountByProfil() {
        return em.createQuery(
                        "SELECT p.libelle, COUNT(participant) " +
                                "FROM Profil p LEFT JOIN p.participants participant " +
                                "GROUP BY p.libelle", Object[].class)
                .getResultStream()
                .collect(Collectors.toMap(
                        o -> (String) o[0],
                        o -> (Long) o[1]
                ));
    }
}
