package tn.gs.projet.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.Objects;

@Setter
@Getter
@Embeddable
@Data
public class FormationParticipantId implements Serializable {
    
    private Long formationId;
    private Long participantId;

    public FormationParticipantId(){};
    public FormationParticipantId(Long formationId, Long participantId) {
        this.formationId = formationId;
        this.participantId = participantId;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof FormationParticipantId)) return false;
        FormationParticipantId that = (FormationParticipantId) o;
        return Objects.equals(formationId, that.formationId) &&
                Objects.equals(participantId, that.participantId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(formationId, participantId);
    }
}
