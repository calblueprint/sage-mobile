package blueprint.com.sage.events.semesters;

import java.util.List;

import blueprint.com.sage.models.Semester;
import lombok.Data;

/**
 * Created by charlesx on 1/3/16.
 */
public @Data class SemesterListEvent {

    private List<Semester> semesters;

    public SemesterListEvent(List<Semester> semesters) { this.semesters = semesters; }
}
