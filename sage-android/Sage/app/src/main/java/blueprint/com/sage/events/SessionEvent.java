package blueprint.com.sage.events;

import blueprint.com.sage.models.Session;
import lombok.Data;

/**
 * Created by charlesx on 1/26/16.
 */
@Data
public class SessionEvent {

    private Session session;

    public SessionEvent(Session session) { this.session = session; }
}
