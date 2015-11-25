package blueprint.com.sage.network.users;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;
import blueprint.com.sage.utility.network.NetworkUtils;

/**
 * Created by charlesx on 11/24/15.
 */
public class EditUserRequest extends BaseRequest {
    public EditUserRequest(final Activity activity, User user,
                           final Response.Listener<User> onSuccess,
                           final Response.Listener<APIError> onFailure) {
        super(Method.PUT, makeUrl(null, "users", String.valueOf(user.getId()), "edit"), NetworkUtils.convertToUserParams(user),
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
}
