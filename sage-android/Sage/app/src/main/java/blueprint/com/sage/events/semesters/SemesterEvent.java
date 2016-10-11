package blueprint.com.sage.events.semesters;

import blueprint.com.sage.models.Semester;
import lombok.Data;

/**
 * Created by charlesx on 1/8/16.
 */
@Data
public class SemesterEvent {
    private Semester semester;

    public SemesterEvent(Semester semester) { this.semester = semester; }
}
