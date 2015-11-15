package blueprint.com.sage.network.users;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 11/14/15.
 * Gets a list of users
 */
public class UserListRequest extends BaseRequest {
    public UserListRequest(final Activity activity,
                           HashMap<String, String> queryParams,
                           final Response.Listener<ArrayList<User>> onSuccess,
                           Response.Listener<APIError> onFailure) {
        super(Method.GET, makeUrl(queryParams, "users"), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String usersString = o.getString("users");
                            ArrayList<User> users = mapper.readValue(usersString, new TypeReference<ArrayList<User>>() {});
                            onSuccess.onResponse(users);
                        } catch(Exception e) {
                            Log.e(getClass().toString(), e.toString());
                        }

                    }
                }, new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {

                    }
        }, activity);
    }

    public static String makeUrl(Boolean verified) {
        HashMap<String, String> queryParams = new HashMap<>();

        if (verified != null)
            queryParams.put("verified", String.valueOf(verified));

        return makeUrl(queryParams, "users");
    }
}
