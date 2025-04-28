package tn.gs.projet.filter;

import jakarta.persistence.EntityManager;
import jakarta.persistence.Persistence;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter(urlPatterns = "/*") // Intercepte toutes les requêtes
public class PersistenceFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        EntityManager em = Persistence.createEntityManagerFactory("trainingPU").createEntityManager();
        request.setAttribute("entityManager", em); // Stocke l'EntityManager dans la requête

        try {
            chain.doFilter(request, response); // Passe à la suite
        } finally {
            em.close(); // Ferme l'EntityManager après traitement
        }
    }
}