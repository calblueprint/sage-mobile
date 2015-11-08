package blueprint.com.sage.network.check_ins;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 10/17/15.
 * Creates a check in
 */
public class CreateCheckInRequest extends BaseRequest {
    public CreateCheckInRequest(final Activity activity, final CheckIn checkIn,
                               final Response.Listener<CheckIn> onSuccess,
                               final Response.Listener<APIError> onFailure) {
        super(Method.POST, makeUrl("/check_ins"), convertToParams(checkIn, "check_in", activity),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String checkInString = o.getString("check_in");
                            CheckIn checkIn = mapper.readValue(checkInString, new TypeReference<CheckIn>() {});
                            onSuccess.onResponse(checkIn);
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
