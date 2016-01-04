package blueprint.com.sage.events.users;

import blueprint.com.sage.models.User;
import lombok.Data;

/**
 * Created by charlesx on 1/4/16.
 */
public @Data class StatusUserEvent {
    private User user;

    public StatusUserEvent(User user) { this.user = user; }
}
