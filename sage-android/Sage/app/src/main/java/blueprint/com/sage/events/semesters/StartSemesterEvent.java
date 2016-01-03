package blueprint.com.sage.events.semesters;

import blueprint.com.sage.models.Semester;
import lombok.Data;

/**
 * Created by charlesx on 1/3/16.
 */
public @Data class StartSemesterEvent {

    private Semester semester;

    public StartSemesterEvent(Semester semester) { this.semester = semester; }
}
