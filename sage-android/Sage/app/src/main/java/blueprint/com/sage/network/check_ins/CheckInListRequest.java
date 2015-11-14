package blueprint.com.sage.network.check_ins;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 11/10/15.
 */
public class CheckInListRequest extends BaseRequest {

    public CheckInListRequest(final Activity activity,
                              Boolean isVerified,
                              final Response.Listener<ArrayList<CheckIn>> onSuccess,
                              final Response.Listener<APIError> onFailure) {
        super(Method.GET, makeUrl(isVerified), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject o) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String checkInString = o.getString("check_ins");
                            ArrayList<CheckIn> checkIns = mapper.readValue(checkInString, new TypeReference<ArrayList<CheckIn>>() {});
                            onSuccess.onResponse(checkIns);
                        } catch(Exception e) {
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

    private static String makeUrl(Boolean isVerified) {
        HashMap<String, String> queryParams = new HashMap<>();

        if (isVerified != null)
            queryParams.put("verified", String.valueOf(isVerified));

        return makeUrl(queryParams, "check_ins");
    }
}
