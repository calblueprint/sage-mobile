package blueprint.com.sage.events.users;

import blueprint.com.sage.models.User;
import lombok.Data;

/**
 * Created by charlesx on 11/14/15.
 */
public @Data class DeleteUserEvent {

    private User user;
    private int position;

    public DeleteUserEvent(User user, int position) {
        this.user = user;
        this.position = position;
    }
}
