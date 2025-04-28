package tn.gs.projet.dao;


import jakarta.persistence.*;
import tn.gs.projet.model.Employeur;
import java.util.List;

public class EmployeurDao {
    private EntityManager em;



    public EmployeurDao() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("trainingPU");
        em = emf.createEntityManager();
    }

    public void saveOrUpdate(Employeur employeur) {
        em.getTransaction().begin();
        if (employeur.getId() == null) em.persist(employeur);
        else em.merge(employeur);
        em.getTransaction().commit();
    }

    public List<Employeur> findAll() {
        return em.createQuery("SELECT e FROM Employeur e", Employeur.class).getResultList();
    }

    public Employeur findById(Long id) {
        return em.find(Employeur.class, id);
    }

    public void delete(Long id) {
        em.getTransaction().begin();
        Employeur employeur = em.find(Employeur.class, id);
        if (employeur != null) em.remove(employeur);
        em.getTransaction().commit();
    }
}
