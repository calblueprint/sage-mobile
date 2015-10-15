package blueprint.com.sage.network.schools;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;

import blueprint.com.sage.models.School;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 10/14/15.
 * Gets ArrayList of schools
 */
public class SchoolListRequest extends BaseRequest {
    public SchoolListRequest(final Activity activity,
                             final Response.Listener<ArrayList<School>> onSuccess,
                             final Response.Listener onFailure) {
        super(Method.GET, makeUrl("/schools"), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        try {
                            String schoolString = o.get("schools").toString();
                            ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                            ArrayList<School> schools =
                                    mapper.readValue(schoolString, new TypeReference<ArrayList<School>>() {
                                    });
                            onSuccess.onResponse(schools);
                        } catch (Exception e) {
                            Log.e(getClass().toString(), e.toString());
                        }
                    }
                },
                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError volleyError) {
                        onFailure.onResponse(volleyError);
                    }
                }, activity);
    }
}
