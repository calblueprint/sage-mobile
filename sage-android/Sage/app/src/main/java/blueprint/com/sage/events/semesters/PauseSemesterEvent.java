package blueprint.com.sage.events.semesters;

import blueprint.com.sage.models.Semester;
import lombok.Data;

/**
 * Created by charlesx on 6/22/16.
 */
@Data
public class PauseSemesterEvent {
    private Semester semester;

    public PauseSemesterEvent(Semester semester) {
        this.semester = semester;
    }
}
