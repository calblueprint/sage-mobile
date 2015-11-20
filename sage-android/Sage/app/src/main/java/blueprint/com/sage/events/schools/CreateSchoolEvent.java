package blueprint.com.sage.events.schools;

import blueprint.com.sage.models.School;
import lombok.Data;

/**
 * Created by charlesx on 11/17/15.
 */
public @Data class CreateSchoolEvent {

    private School school;

    public CreateSchoolEvent(School school) {
        this.school = school;
    }
}
