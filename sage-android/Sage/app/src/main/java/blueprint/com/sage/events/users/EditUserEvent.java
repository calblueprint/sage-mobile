package blueprint.com.sage.events.users;

import blueprint.com.sage.models.User;
import lombok.Data;

/**
 * Created by charlesx on 11/26/15.
 */
public @Data class EditUserEvent {

    private User user;

    public EditUserEvent(User user) { this.user = user; }
}
