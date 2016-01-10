package blueprint.com.sage.network.user_semesters;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.UserSemester;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 1/9/16.
 */
public class UpdateUserSemesterRequest extends BaseRequest {
    public UpdateUserSemesterRequest(final Activity activity, UserSemester userSemester,
                                     final Response.Listener<UserSemester> onSuccess,
                                     final Response.Listener<APIError> onFailure) {
        super(Method.PUT, makeUrl(null, "admin", "user_semesters", String.valueOf(userSemester.getId())),
                convertToParams(userSemester, "user_semester", activity),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String userSemesterString = jsonObject.getString("user_semester");
                            UserSemester userSemester = mapper.readValue(userSemesterString, new TypeReference<UserSemester>() {});
                            onSuccess.onResponse(userSemester);
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
