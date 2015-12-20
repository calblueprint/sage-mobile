package blueprint.com.sage.events.sessions;

import blueprint.com.sage.models.Session;
import lombok.Data;

/**
 * Created by charlesx on 12/20/15.
 */
public @Data class SignInEvent {
    private Session session;

    public SignInEvent(Session session) {
        this.session = session;
    }
}
