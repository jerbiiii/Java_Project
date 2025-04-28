package tn.gs.projet.model;

import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.annotations.Cascade;

import java.util.Date;

@Entity
@Data
@Table(name = "formation_participant")
public class FormationParticipant {
    @EmbeddedId
    private FormationParticipantId id = new FormationParticipantId();

    @ManyToOne
    @MapsId("formationId")
    @JoinColumn(name = "formation_id")
    private Formation formation;

    @ManyToOne
    @MapsId("participantId")
    @JoinColumn(name = "participant_id")
    @Cascade(org.hibernate.annotations.CascadeType.MERGE)
    private Participant participant;

    @Column(name = "DateInscription")
    private Date dateInscription;


}
