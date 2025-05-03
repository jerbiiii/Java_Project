package tn.gs.projet.model;


import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "Structure")
public class Structure {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String libelle; // Ex: "Direction Centrale", "Direction Régionale"


}
