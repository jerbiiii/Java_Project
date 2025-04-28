package tn.gs.projet.dao;


import jakarta.persistence.*;
import tn.gs.projet.model.Role;

import java.util.List;

public class RoleDao {
    private EntityManager em;

    public RoleDao() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("trainingPU");
        em = emf.createEntityManager();
    }

    public void saveOrUpdate(Role role) {
        em.getTransaction().begin();
        if (role.getId() == null) em.persist(role);
        else em.merge(role);
        em.getTransaction().commit();
    }

    public List<Role> findAll() {
        return em.createQuery("SELECT r FROM Role r", Role.class).getResultList();
    }

    public Role findById(Long id) {
        return em.find(Role.class, id);
    }

    public void delete(Long id) {
        em.getTransaction().begin();
        Role role = em.find(Role.class, id);
        if (role != null) em.remove(role);
        em.getTransaction().commit();
    }
}
