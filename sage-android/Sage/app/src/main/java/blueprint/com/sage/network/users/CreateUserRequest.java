package blueprint.com.sage.network.users;

import android.app.Activity;

import com.android.volley.Response;
import com.android.volley.VolleyError;

import org.json.JSONObject;

import blueprint.com.sage.models.User;
import blueprint.com.sage.network.BaseRequest;

/**
 * Created by charlesx on 10/13/15.
 * Creates a user
 */
public class CreateUserRequest extends BaseRequest {
    public CreateUserRequest(Activity activity, User user,
                             final Response.Listener<JSONObject> onSuccess,
                             final Response.ErrorListener onFailure) {
        super(Method.POST, makeUrl("/users"), convertToParams(user, activity),
         new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject o) {
                onSuccess.onResponse(o);
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                onFailure.onErrorResponse(error);
            }
        }, activity);
    }
}
