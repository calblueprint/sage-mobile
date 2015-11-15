package blueprint.com.sage.events.users;

import blueprint.com.sage.models.User;
import lombok.Data;

/**
 * Created by charlesx on 11/14/15.
 */
public @Data class VerifyUserEvent {

    private User user;

    public VerifyUserEvent(User user) {
        this.user = user;
    }
}
