package blueprint.com.sage.events.semesters;

import blueprint.com.sage.models.Semester;
import lombok.Data;

/**
 * Created by charlesx on 1/3/16.
 */
public @Data class FinishSemesterEvent {

    private Semester semester;

    public FinishSemesterEvent(Semester semester) { this.semester = semester; }
}
