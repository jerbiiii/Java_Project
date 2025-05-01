package tn.gs.projet.dao;


import jakarta.persistence.*;
import tn.gs.projet.model.Domaine;
import java.util.List;


public class DomaineDao {
    private EntityManager em;

    public DomaineDao(EntityManager em) {
        this.em = em;
    }

    public DomaineDao() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("trainingPU");
        em = emf.createEntityManager();
    }

    public void saveOrUpdate(Domaine domaine) {
        em.getTransaction().begin();
        if (domaine.getId() == null) em.persist(domaine);
        else em.merge(domaine);
        em.getTransaction().commit();
    }

    public List<Domaine> findAll() {
        return em.createQuery("SELECT d FROM Domaine d", Domaine.class).getResultList();
    }

    public Domaine findById(Long id) {
        return em.find(Domaine.class, id);
    }

    public void delete(Long id) {
        em.getTransaction().begin();
        Domaine domaine = em.find(Domaine.class, id);
        if (domaine != null) em.remove(domaine);
        em.getTransaction().commit();
    }

}