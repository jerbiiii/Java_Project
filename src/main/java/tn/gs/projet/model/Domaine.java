package tn.gs.projet.model;



import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@Table(name = "Domaine")
public class Domaine {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String libelle; // Ex: "Informatique", "Finance"
    @OneToMany(mappedBy = "domaine", cascade = CascadeType.ALL)
    @EqualsAndHashCode.Exclude
    private List<Formation> formations = new ArrayList<>();
}
