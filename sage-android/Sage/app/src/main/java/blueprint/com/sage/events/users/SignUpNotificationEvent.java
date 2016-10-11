package blueprint.com.sage.events.users;

import android.content.Context;

import com.fasterxml.jackson.core.type.TypeReference;

import blueprint.com.sage.models.User;
import blueprint.com.sage.utility.network.NetworkUtils;
import lombok.Data;

/**
 * Created by charlesx on 6/2/16.
 */
@Data
public class SignUpNotificationEvent {

    private User user;

    public SignUpNotificationEvent(Context context, String objectString) {
        this.user = NetworkUtils.writeAsObject(context, objectString, new TypeReference<User>() {});
    }
}
