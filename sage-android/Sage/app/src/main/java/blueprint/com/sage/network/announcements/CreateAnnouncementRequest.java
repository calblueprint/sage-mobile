package blueprint.com.sage.network.announcements;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.network.BaseRequest;

/**
 * Created by kelseylam on 11/12/15.
 */
public class CreateAnnouncementRequest extends BaseRequest {

    public CreateAnnouncementRequest(final Activity activity, Announcement announcement,
                                    final Response.Listener<Session> listener, final Response.Listener<APIError> errorListener) {
        super(Request.Method.POST, makeUrl("/announcements"), createAnnouncementParams(announcement),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String sessionString = jsonObject.get("string").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            Session session = mapper.readValue(sessionString, new TypeReference<Session>() {
                            });
                            listener.onResponse(session);
                        } catch (Exception e) {
                            Log.e(getClass().toString(), e.toString());
                        }
                    }
                }, errorListener, activity);
    }

    public static JSONObject createAnnouncementParams(Announcement announcement) {
        HashMap<String, JSONObject> params = new HashMap<>();
        JSONObject announcementObject = new JSONObject();
        try {
            announcementObject.put("title", announcement.getTitle());
            announcementObject.put("created_at", announcement.getCreatedAt());
            announcementObject.put("body", announcement.getBody());
            announcementObject.put("user_id", announcement.getUserId());
            announcementObject.put("school_id", announcement.getSchoolId());
            announcementObject.put("user", announcement.getUser());
            announcementObject.put("school", announcement.getSchool());
            announcementObject.put("category", announcement.getCategory());
        } catch(JSONException e) {
            Log.e(CreateAnnouncementRequest.class.toString(), e.toString());
        }
        params.put("announcement", announcementObject);
        return new JSONObject(params);
    }
}
