package blueprint.com.sage.network.check_ins;

import android.app.Activity;

import com.android.volley.Response;

import org.json.JSONObject;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.network.BaseRequest;

/**
 * Created by charlesx on 10/17/15.
 * Creates a check in
 */
public class CreateCheckInRequest extends BaseRequest {
    public CreateCheckInRequest(Activity activity, CheckIn checkIn,
                               Response.Listener<CheckIn> onSuccess,
                               final Response.Listener<APIError> onFailure) {
        super(Method.POST, makeUrl("/check_ins"), convertToParams(checkIn, activity),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {

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
