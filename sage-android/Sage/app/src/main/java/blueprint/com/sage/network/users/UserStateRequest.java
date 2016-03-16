package blueprint.com.sage.network.users;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 1/26/16.
 */
public class UserStateRequest extends BaseRequest {
    public UserStateRequest(final Activity activity, User user,
                            final Response.Listener<Session> onSuccess,
                            final Response.Listener<APIError> onError) {
        super(Method.GET, makeUrl(activity, null, "users", String.valueOf(user.getId()), "state"), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        ObjectMapper objectMapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String sessionString = o.getString("session");
                            Session session = objectMapper.readValue(sessionString, new TypeReference<Session>() {});
                            onSuccess.onResponse(session);
                        } catch(Exception e) {
                            Log.e(getClass().toString(), e.toString());
                        }
                    }
                },
                new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError apiError) {
                        onError.onResponse(apiError);
                    }
                }, activity);
    }
}
