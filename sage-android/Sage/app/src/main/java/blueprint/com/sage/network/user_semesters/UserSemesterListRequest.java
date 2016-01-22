package blueprint.com.sage.network.user_semesters;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.UserSemester;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 1/17/16.
 */
public class UserSemesterListRequest extends BaseRequest {
    public UserSemesterListRequest(final Activity activity, HashMap<String, String> queryParams,
                                   final Response.Listener<List<UserSemester>> onSuccess,
                                   final Response.Listener<APIError> onFailure) {
        super(Request.Method.GET, makeUrl(queryParams, "admin", "user_semesters"), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String userSemesterString = o.getString("user_semesters");
                            List<UserSemester> userSemesters =
                                    mapper.readValue(userSemesterString, new TypeReference<List<UserSemester>>() {});
                            onSuccess.onResponse(userSemesters);
                        } catch(Exception e) {
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
