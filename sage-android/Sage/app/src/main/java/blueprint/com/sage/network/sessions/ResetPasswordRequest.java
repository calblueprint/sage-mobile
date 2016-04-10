package blueprint.com.sage.network.sessions;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.APISuccess;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 4/9/16.
 */
public class ResetPasswordRequest extends BaseRequest {
    public ResetPasswordRequest(final Activity activity, HashMap<String, String> params,
                                 final Response.Listener<APISuccess> onSuccess,
                                 final Response.Listener<APIError> onError) {
        super(Method.POST, makeUrl(activity, null, "users", "reset"), convertToParams(params), new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject o) {
                ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                try {
                    String successString = o.getString("success");
                    APISuccess success = mapper.readValue(successString, new TypeReference<APISuccess>() {});
                    onSuccess.onResponse(success);
                } catch(Exception e) {
                    Log.e(getClass().toString(), e.toString());
                }
            }
        }, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError e) {
                onError.onResponse(e);
            }
        }, activity);
    }
}
