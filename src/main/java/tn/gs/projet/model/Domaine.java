package tn.gs.projet.model;

import jakarta.persistence.*;
import lombok.Data;


@Entity
@Data
@Table(name = "Domaine")
public class Domaine {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String libelle; // Ex: "Informatique", "Finance"

}
