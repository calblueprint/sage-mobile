package blueprint.com.sage.events.users;

import blueprint.com.sage.models.User;
import lombok.Data;

/**
 * Created by charlesx on 11/19/15.
 */
public @Data class CreateAdminEvent {

    private User user;

    public CreateAdminEvent(User user) { this.user = user; }
}
