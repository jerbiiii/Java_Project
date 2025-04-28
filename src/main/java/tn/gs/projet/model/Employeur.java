package tn.gs.projet.model;


import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "Employeur")
public class Employeur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String nomEmployeur; // Ex: "Green Building"
}
