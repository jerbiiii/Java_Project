package tn.gs.projet.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
@Table(name = "Utilisateur")
public class Utilisateur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String login;

    @Column(nullable = false)
    private String password;

    @ManyToOne
    @JoinColumn(name = "idRole")
    private Role role;

    public String getRoleName() {
        return role != null ? role.getNom() : "";
    }
}