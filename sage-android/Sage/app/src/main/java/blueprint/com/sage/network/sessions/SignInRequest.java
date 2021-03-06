package blueprint.com.sage.network.sessions;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.network.BaseRequest;

/**
 * Created by kelseylam on 10/14/15.
 */
public class SignInRequest extends BaseRequest {
    public SignInRequest(final Activity activity, HashMap<String, String> params,
                         final Response.Listener<Session> listener, final Response.Listener<APIError> errorListener) {
        super(Request.Method.POST, makeUrl(activity, null, "users", "sign_in"), loginRequestParams(params),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String sessionJson = jsonObject.get("session").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            Session session = mapper.readValue(sessionJson, new TypeReference<Session>() {
                            });
                            listener.onResponse(session);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }
                }, errorListener, activity);
    }
    
    public static JSONObject loginRequestParams(HashMap<String, String> userParams) {
        JSONObject userJson = new JSONObject(userParams);
        HashMap<String, JSONObject> params = new HashMap<>();
        params.put("user", userJson);
        return new JSONObject(params);
    }
}

