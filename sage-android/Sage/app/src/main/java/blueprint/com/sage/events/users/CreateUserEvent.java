package blueprint.com.sage.events.users;

import blueprint.com.sage.models.Session;
import lombok.Data;

/**
 * Created by charlesx on 11/19/15.
 */
public @Data class CreateUserEvent {
    private Session session;

    public CreateUserEvent(Session session) { this.session = session; }
}
