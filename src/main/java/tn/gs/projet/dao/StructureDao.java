package tn.gs.projet.dao;



import jakarta.persistence.*;
import jakarta.transaction.Transactional;
import tn.gs.projet.model.Structure;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class StructureDao {
    private EntityManager em;

    public StructureDao() {
        EntityManagerFactory emf = Persistence.createEntityManagerFactory("trainingPU");
        em = emf.createEntityManager();
    }

    public void saveOrUpdate(Structure structure) {
        em.getTransaction().begin();
        if (structure.getId() == null) em.persist(structure);
        else em.merge(structure);
        em.getTransaction().commit();
    }

    public List<Structure> findAll() {
        return em.createQuery("SELECT s FROM Structure s", Structure.class).getResultList();
    }

    public Structure findById(Long id) {
        return em.find(Structure.class, id);
    }

    public void delete(Long id) {
        em.getTransaction().begin();
        Structure structure = em.find(Structure.class, id);
        if (structure != null) em.remove(structure);
        em.getTransaction().commit();
    }

    @Transactional
    public Map<String, Long> getParticipantsCountByStructure() {
        return em.createQuery(
                        "SELECT s.libelle, COUNT(participant) " +
                                "FROM Structure s LEFT JOIN s.participants participant " +
                                "GROUP BY s.libelle", Object[].class)
                .getResultStream()
                .collect(Collectors.toMap(
                        o -> (String) o[0],
                        o -> (Long) o[1]
                ));
    }
}
