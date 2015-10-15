package blueprint.com.sage.network.users;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import blueprint.com.sage.models.User;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 10/13/15.
 * Creates a user
 */
public class CreateUserRequest extends BaseRequest {
    public CreateUserRequest(final Activity activity, User user,
                             final Response.Listener<User> onSuccess,
                             final Response.ErrorListener onFailure) {
        super(Method.POST, makeUrl("/users"), convertToParams(user, activity),
         new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject o) {
                try {
                    String userString = o.getString("user").toString();
                    ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                    User user = mapper.readValue(userString, new TypeReference<User>() {});
                    onSuccess.onResponse(user);
                } catch (Exception e) {
                    Log.e(getClass().toString(), e.toString());
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                onFailure.onErrorResponse(error);
            }
        }, activity);
    }
}
