package tn.gs.projet.model;


import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.util.ArrayList;
import java.util.List;

@Entity
@Data
@Table(name = "Participant")
public class Participant {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nom;
    private String prenom;
    private String email;
    private int tel;

    @ManyToOne
    @JoinColumn(name = "idStructure")
    @EqualsAndHashCode.Exclude
    private Structure structure;

    @ManyToOne
    @JoinColumn(name = "idProfil")
    private Profil profil;

    @OneToMany(mappedBy = "participant", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<FormationParticipant> formations = new ArrayList<>();
}
