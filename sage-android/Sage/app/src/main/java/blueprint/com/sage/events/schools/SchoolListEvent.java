package blueprint.com.sage.events.schools;

import java.util.List;

import blueprint.com.sage.models.School;
import lombok.Data;

/**
 * Created by charlesx on 11/8/15.
 */
public @Data class SchoolListEvent {
    private List<School> schools;

    public SchoolListEvent(List<School> schools) {
        this.schools = schools;
    }
}
