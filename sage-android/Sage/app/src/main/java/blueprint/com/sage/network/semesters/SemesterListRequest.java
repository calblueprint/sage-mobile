package blueprint.com.sage.network.semesters;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 1/3/16.
 */
public class SemesterListRequest extends BaseRequest {
    public SemesterListRequest(final Activity activity, HashMap<String, String> queryParams,
                                 final Response.Listener<List<Semester>> onSuccess,
                                 final Response.Listener<APIError> onFailure) {
        super(Method.GET, makeUrl(queryParams, "semesters"), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String semesterString = o.getString("semesters");
                            ArrayList<Semester> semester =
                                    mapper.readValue(semesterString, new TypeReference<List<Semester>>() {});
                            onSuccess.onResponse(semester);
                        } catch(Exception e) {
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
