package blueprint.com.sage.network.users;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 11/28/15.
 */
public class PromoteUserRequest extends BaseRequest {
    public PromoteUserRequest(final Activity activity, User user,
                              final Response.Listener<User> onSuccess,
                              final Response.Listener<APIError> onFailure) {
        super(Method.POST, makeUrl(null, "admin", "users", String.valueOf(user.getId()), "promote"), convertToParams(user),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String userString = o.getString("user");
                            User user = mapper.readValue(userString, new TypeReference<User>() {});
                            onSuccess.onResponse(user);
                        } catch(Exception e) {
                            Log.e(getClass().toString(), e.toString());
                        }
                    }
                }, new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {
                        onFailure.onResponse(error);
                    }
                }, activity);
    }

    private static JSONObject convertToParams(User user) {
        HashMap<String, JSONObject> params = new HashMap<>();
        JSONObject userObject = new JSONObject();

        try {
            userObject.put("role", user.getRoleInt());
        } catch(JSONException e) {
            Log.e(PromoteUserRequest.class.toString(), e.toString());
        }

        params.put("user", userObject);
        return new JSONObject(params);
    }
}
