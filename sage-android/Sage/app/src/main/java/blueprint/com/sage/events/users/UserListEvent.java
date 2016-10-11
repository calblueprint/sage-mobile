package blueprint.com.sage.events.users;

import java.util.List;

import blueprint.com.sage.models.User;
import lombok.Data;

/**
 * Created by charlesx on 11/14/15.
 */
public @Data class UserListEvent {
    private List<User> users;

    public UserListEvent(List<User> users) {
        this.users = users;
    }
}
