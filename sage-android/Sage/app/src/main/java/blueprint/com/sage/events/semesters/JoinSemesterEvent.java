package blueprint.com.sage.events.semesters;

import blueprint.com.sage.models.Session;

/**
 * Created by charlesx on 1/29/16.
 */
public class JoinSemesterEvent {

    private Session session;

    public JoinSemesterEvent(Session session) { this.session = session; }
}
