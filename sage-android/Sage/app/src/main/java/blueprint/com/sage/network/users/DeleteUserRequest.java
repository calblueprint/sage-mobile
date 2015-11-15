package blueprint.com.sage.network.users;

import android.app.Activity;

import com.android.volley.Response;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.BaseRequest;

/**
 * Created by charlesx on 11/14/15.
 */
public class DeleteUserRequest extends BaseRequest {
    public DeleteUserRequest(Activity activity, User user,
                             Response.Listener<User> onSuccess,
                             Response.Listener<APIError> onFailure) {
        super(Method.DELETE, makeUrl(null, "users", String.valueOf(user.getId())), null,
                new Response.Listener() {
                    @Override
                    public void onResponse(Object o) {

                    }
            }, new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError error) {

                }
            }, activity);
    }
}
