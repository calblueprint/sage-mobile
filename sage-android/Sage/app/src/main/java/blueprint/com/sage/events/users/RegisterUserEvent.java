package blueprint.com.sage.events.users;

import blueprint.com.sage.models.Session;
import lombok.Data;

/**
 * Created by charlesx on 4/18/16.
 */
@Data
public class RegisterUserEvent {
    private Session session;

    public RegisterUserEvent(Session session) { this.session = session; }
}
