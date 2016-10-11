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
 * Created by charlesx on 11/10/15.
 */
public class VerifyCheckInRequest extends BaseRequest {
    public VerifyCheckInRequest(final Activity activity, CheckIn checkIn,
                                final Response.Listener<CheckIn> onSuccess,
                                final Response.Listener<APIError> onFailure) {
        super(Method.POST, makeUrl(checkIn), null,
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

    private static String makeUrl(CheckIn checkIn) {
        return makeUrl(null, "admin", "check_ins", String.valueOf(checkIn.getId()), "verify");
    }
}
