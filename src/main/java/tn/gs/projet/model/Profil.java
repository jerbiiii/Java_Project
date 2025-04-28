package tn.gs.projet.model;


import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@Table(name = "Profil")
public class Profil {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String libelle; // Ex: "Informaticien (bac +5)", "Gestionnaire"

    @OneToMany(mappedBy = "profil", cascade = CascadeType.ALL)
    @EqualsAndHashCode.Exclude
    private List<Participant> participants = new ArrayList<>();
}
