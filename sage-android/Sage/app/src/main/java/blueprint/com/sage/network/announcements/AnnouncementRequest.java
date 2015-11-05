package blueprint.com.sage.network.announcements;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.HashMap;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.BaseRequest;

/**
 * Created by kelseylam on 11/4/15.
 */
public class AnnouncementRequest extends BaseRequest{
    public AnnouncementRequest(final Activity activity, int id,
                               final Response.Listener<Announcement> listener, final Response.Listener<APIError> errorListener) {
        super(Request.Method.GET, makeUrl(null, "announcements", String.valueOf(id)), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String announcementJson = jsonObject.get("announcement").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            Announcement announcement = mapper.readValue(announcementJson, new TypeReference<Announcement>() {});
                            listener.onResponse(announcement);
                        } catch (Exception e) {
                            Log.e("Json exception", e.toString());
                        }
                    }
                }, errorListener, activity);
    }

    public static JSONObject announcementParams(HashMap<String, String> announcementParams) {
        JSONObject announcementJson = new JSONObject(announcementParams);
        HashMap<String, JSONObject> params = new HashMap<>();
        params.put("announcement", announcementJson);
        return new JSONObject(params);
    }
}
