package tn.gs.projet.dao;


import jakarta.persistence.*;
import tn.gs.projet.model.Formateur;
import java.util.List;

public class FormateurDao {
    private EntityManager em;

    public FormateurDao() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("trainingPU");
        em = emf.createEntityManager();
    }

    public void saveOrUpdate(Formateur formateur) {
        em.getTransaction().begin();
        if (formateur.getId() == null) em.persist(formateur);
        else em.merge(formateur);
        em.getTransaction().commit();
    }

    public List<Formateur> findAll() {
        return em.createQuery("SELECT f FROM Formateur f", Formateur.class).getResultList();
    }

    public Formateur findById(Long id) {
        return em.find(Formateur.class, id);
    }

    public void delete(Long id) {
        em.getTransaction().begin();
        Formateur formateur = em.find(Formateur.class, id);
        if (formateur != null) em.remove(formateur);
        em.getTransaction().commit();
    }
}
