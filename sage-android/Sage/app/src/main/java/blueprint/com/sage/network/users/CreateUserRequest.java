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
 * Created by charlesx on 10/13/15.
 * Creates a user
 */
public class CreateUserRequest extends BaseRequest {
    public CreateUserRequest(final Activity activity, User user,
                             final Response.Listener<Session> onSuccess,
                             final Response.Listener onFailure) {
        super(Method.POST, makeUrl(null, "users"), convertToParams(user, "user", activity),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        try {
                            String sessionString = o.getString("session");
                            ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                            Session session = mapper.readValue(sessionString, new TypeReference<Session>() {
                            });
                            onSuccess.onResponse(session);
                        } catch (Exception e) {
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
