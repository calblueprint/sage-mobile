package blueprint.com.sage.events.schools;

import blueprint.com.sage.models.School;
import lombok.Data;

/**
 * Created by charlesx on 11/21/15.
 */
public @Data class SchoolEvent {
    private School school;

    public SchoolEvent(School school) {
        this.school = school;
    }
}
