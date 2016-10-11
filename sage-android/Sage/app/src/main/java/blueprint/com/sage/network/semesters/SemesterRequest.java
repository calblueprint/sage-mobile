package blueprint.com.sage.network.semesters;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 1/8/16.
 */
public class SemesterRequest extends BaseRequest {
    public SemesterRequest(final Activity activity, Semester semester,
                           final Response.Listener<Semester> onSuccess,
                           final Response.Listener<APIError> onFailure) {
        super(Method.GET, makeUrl(null, "semesters", String.valueOf(semester.getId())), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String semesterString = jsonObject.getString("semester");
                            Semester semester = mapper.readValue(semesterString, new TypeReference<Semester>() {});
                            onSuccess.onResponse(semester);
                        } catch(Exception e) {
                            Log.e(getClass().toString(), e.toString());
                        }
                    }
                }, new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError apiError) {
                        onFailure.onResponse(apiError);
                    }
                }, activity);
    }
}
