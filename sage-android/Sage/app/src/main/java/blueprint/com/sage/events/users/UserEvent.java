package blueprint.com.sage.events.users;

import blueprint.com.sage.models.User;
import lombok.Data;

/**
 * Created by charlesx on 11/22/15.
 */
public @Data class UserEvent {

    private User user;

    public UserEvent(User user) { this.user = user; }
}
