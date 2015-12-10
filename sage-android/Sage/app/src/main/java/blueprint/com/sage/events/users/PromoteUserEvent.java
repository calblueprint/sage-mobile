package blueprint.com.sage.events.users;

import blueprint.com.sage.models.User;
import lombok.Data;

/**
 * Created by charlesx on 11/28/15.
 */
public @Data class PromoteUserEvent {

    private User user;

    public PromoteUserEvent(User user) { this.user = user; }
}
