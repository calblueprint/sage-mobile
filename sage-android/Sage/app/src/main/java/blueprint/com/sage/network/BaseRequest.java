package blueprint.com.sage.network;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.NetworkResponse;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.apache.http.HttpStatus;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import blueprint.com.sage.R;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.utility.network.NetworkManager;
import blueprint.com.sage.utility.network.NetworkUtils;

/**
 * Created by charlesx on 9/25/15.
 */
public class BaseRequest extends JsonObjectRequest {

    private static final String mBaseUrl = "http://sage-rails.herokuapp.com/api/v1";

    private Activity mActivity;

    public BaseRequest(int requestType, String url, JSONObject params,
                       Response.Listener<JSONObject> onSuccess, final Response.Listener<APIError> onFailure, final Activity activity) {
        super(requestType, url, params, onSuccess, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                Log.e("Request Error", "Custom ErrorListener detected");
                NetworkResponse networkResponse = volleyError.networkResponse;
                APIError apiError = new APIError();
                if (networkResponse == null) {
                    if (!NetworkUtils.isConnectedToInternet(activity)) {
                        Toast.makeText(activity, "You're not connected to the internet!", Toast.LENGTH_SHORT).show();
                    } else {
                        Toast.makeText(activity, "Something went wrong - please try again!", Toast.LENGTH_SHORT).show();
                    }
                } else {
                    if (networkResponse.statusCode == HttpStatus.SC_FORBIDDEN) {
                        Toast.makeText(activity, "Invalid email or password.", Toast.LENGTH_SHORT).show();
                        NetworkUtils.logoutCurrentUser(activity);
                    } else {
                        if (networkResponse.data != null) {
                            try {
                                String errorJson = new String(networkResponse.data);
                                JSONObject errorJsonObject = new JSONObject(errorJson);
                                errorJson = errorJsonObject.getString("error");
                                ObjectMapper mapper = getNetworkManager(activity).getObjectMapper();
                                apiError = mapper.readValue(errorJson, new TypeReference<APIError>() {});
                            } catch (Exception e) {
                                Log.e("Json exception base", e.toString());
                            }
                        } Toast.makeText(activity, apiError.getMessage(), Toast.LENGTH_SHORT).show();
                    }

                }
                onFailure.onResponse(apiError);
            };
        });

        mActivity = activity;
    }

    public BaseRequest(int requestType, String url, JSONObject params,
                       Response.Listener onSuccess, Activity activity) {
        this(requestType, url, params, onSuccess, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError apiError) {
                Log.e("BaseRequest", "Did not override");
            }
        }, activity);
    }

    @Override
    public HashMap<String, String> getHeaders() {
        HashMap<String, String> headers = new HashMap<>();
        headers.put(getString(R.string.accept), getString(R.string.json));
        headers.put(getString(R.string.content_type), getString(R.string.json));

        SharedPreferences preferences = mActivity.getSharedPreferences(getString(R.string.preferences), 0);
        String auth_token = preferences.getString(getString(R.string.auth_token), "");
        String email = preferences.getString(getString(R.string.email), "");

        headers.put(getString(R.string.auth_header), auth_token);
        headers.put(getString(R.string.email_header), email);
        return headers;
    }

    public static String makeUrl(String url) { return mBaseUrl + url; }

    public static JSONObject convertToParams(Object object, Context context) {
        ObjectMapper mapper =  NetworkManager.getInstance(context).getObjectMapper();
        JSONObject objectJSON = null;

        try {
            String objectString = mapper.writeValueAsString(object);
            objectJSON = new JSONObject(objectString);
        } catch(JsonProcessingException e) {
            Log.e("Processing Error", e.toString());
        } catch(JSONException e) {
            Log.e("Mapper Failure", e.toString());
        }

        return objectJSON;
    }

    public static NetworkManager getNetworkManager(Context context) {
        return NetworkManager.getInstance(context);
    }

    private String getString(int resId) { return mActivity.getString(resId); }
}
