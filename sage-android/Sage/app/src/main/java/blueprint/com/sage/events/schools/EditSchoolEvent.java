package blueprint.com.sage.events.schools;

import blueprint.com.sage.models.School;
import lombok.Data;

/**
 * Created by charlesx on 11/29/15.
 */
public @Data class EditSchoolEvent {
    private School school;

    public EditSchoolEvent(School school) { this.school = school; }
}
