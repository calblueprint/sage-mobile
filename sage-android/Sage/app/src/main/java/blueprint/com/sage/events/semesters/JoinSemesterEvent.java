package blueprint.com.sage.events.semesters;

import blueprint.com.sage.models.Session;
import lombok.Data;

/**
 * Created by charlesx on 1/29/16.
 */
@Data
public class JoinSemesterEvent {

    private Session session;

    public JoinSemesterEvent(Session session) { this.session = session; }
}
