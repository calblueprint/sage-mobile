package blueprint.com.sage.network.users;

import android.app.Activity;

import com.android.volley.Response;

import org.json.JSONObject;

import blueprint.com.sage.models.User;
import blueprint.com.sage.network.BaseRequest;

/**
 * Created by charlesx on 10/13/15.
 */
public class CreateUserRequest extends BaseRequest {
    public CreateUserRequest(Activity activity, User user,
                             Response.Listener<JSONObject> onSuccess, Response.ErrorListener onFailure) {
        super(Method.POST, makeUrl("/users"), convertToParams(user, activity)
        , (o) -> {
            onSuccess.onResponse(o);
        }, (volleyError) -> {
            onFailure.onErrorResponse(volleyError);
        }, activity);
    }
}
