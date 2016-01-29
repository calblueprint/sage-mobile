package blueprint.com.sage.events.semesters;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 1/29/16.
 * Makes a request to join a semester (if one currently exists)
 */
public class JoinSemesterRequest extends BaseRequest {
    public JoinSemesterRequest(final Activity activity,
                               final Response.Listener<Session> onSuccess,
                               final Response.Listener<APIError> onFailure) {
        super(Method.POST, makeUrl(null, "semesters", "join"), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String sessionString = o.getString("session");
                            Session session = mapper.readValue(sessionString, new TypeReference<Session>() {});
                            onSuccess.onResponse(session);
                        } catch (Exception e) {
                            Log.e(getClass().toString(), e.toString());
                        }

                    }
                },
                new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError apiError) {
                        onFailure.onResponse(apiError);
                    }
                }, activity);
    }
}
