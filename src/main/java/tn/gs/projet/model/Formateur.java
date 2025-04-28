package tn.gs.projet.model;


import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "Formateur")
public class Formateur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nom;
    private String prenom;
    private String email;
    private int tel;
    private String type; // "interne" ou "externe"

    @ManyToOne
    @JoinColumn(name = "idEmployeur")
    private Employeur employeur;
}
