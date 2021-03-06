package blueprint.com.sage.network.schools;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 10/14/15.
 * Gets ArrayList of schools
 */
public class SchoolListRequest extends BaseRequest {
    public SchoolListRequest(final Activity activity,
                             HashMap<String, String> queryParams,
                             final Response.Listener<ArrayList<School>> onSuccess,
                             final Response.Listener<APIError> onFailure) {
        super(Method.GET, makeUrl(activity, queryParams, "schools"), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        try {
                            String schoolString = o.get("schools").toString();
                            ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                            ArrayList<School> schools =
                                    mapper.readValue(schoolString, new TypeReference<ArrayList<School>>() {});
                            onSuccess.onResponse(schools);
                        } catch (Exception e) {
                            Log.e(getClass().toString(), e.toString());
                        }
                    }
                },
                new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {
                        onFailure.onResponse(error);
                    }
                }, activity);
    }
}
