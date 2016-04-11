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
 * Created by charlesx on 1/3/16.
 * Makes request to start a semester
 */
public class StartSemesterRequest extends BaseRequest {
    public StartSemesterRequest(final Activity activity, Semester semester,
                                final Response.Listener<Semester> onSuccess,
                                final Response.Listener<APIError> onFailure) {
        super(Method.POST, makeUrl(activity, null, "admin", "semesters"),
                convertToParams(semester, "semester", activity),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String semesterString = o.getString("semester");
                            Semester semester = mapper.readValue(semesterString, new TypeReference<Semester>() {});
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
