package tn.gs.projet.dao;


import jakarta.persistence.*;
import tn.gs.projet.model.Profil;
import java.util.List;


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

}
