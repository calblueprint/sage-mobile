package blueprint.com.sage.network.schools;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 11/22/15.
 */
public class SchoolRequest extends BaseRequest {
    public SchoolRequest(final Activity activity, School school,
                         HashMap<String, String> queryParams,
                         final Response.Listener<School> onSuccess,
                         final Response.Listener<APIError> onFailure) {
        super(Method.GET, makeUrl(activity, queryParams, "schools", String.valueOf(school.getId())), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String schoolString = o.getString("school");
                            School school = mapper.readValue(schoolString, new TypeReference<School>() {});
                            onSuccess.onResponse(school);
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
