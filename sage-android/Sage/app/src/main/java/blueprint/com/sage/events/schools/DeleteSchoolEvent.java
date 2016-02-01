package blueprint.com.sage.events.schools;

import blueprint.com.sage.models.School;
import lombok.Data;

/**
 * Created by charlesx on 1/28/16.
 */
@Data
public class DeleteSchoolEvent {
    private School school;

    public DeleteSchoolEvent(School school) { this.school = school; }
}
