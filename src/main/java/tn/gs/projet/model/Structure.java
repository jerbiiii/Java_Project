package tn.gs.projet.model;


import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@Table(name = "Structure")
public class Structure {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String libelle; // Ex: "Direction Centrale", "Direction Régionale"

    @OneToMany(mappedBy = "structure", cascade = CascadeType.ALL)
    @EqualsAndHashCode.Exclude
    private List<Participant> participants = new ArrayList<>();


}
