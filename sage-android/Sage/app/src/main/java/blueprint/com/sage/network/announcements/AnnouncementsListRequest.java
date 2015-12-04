package blueprint.com.sage.network.announcements;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.BaseRequest;

/**
 * Created by kelseylam on 11/4/15.
 */
public class AnnouncementsListRequest extends BaseRequest{
    public AnnouncementsListRequest(final Activity activity, HashMap<String, String> params,
                                    final Response.Listener<ArrayList<Announcement>> listener, final Response.Listener<APIError> errorListener) {
        super(Request.Method.GET, makeUrl(params, "announcements"), null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        try {
                            String announcementString = jsonObject.get("announcements").toString();
                            ObjectMapper mapper = getNetworkManager(activity.getApplicationContext()).getObjectMapper();
                            ArrayList<Announcement> announcements = mapper.readValue(announcementString, new TypeReference<ArrayList<Announcement>>() {});
                            listener.onResponse(announcements);
                        } catch (Exception e) {
                            Log.e(getClass().toString(), e.toString());
                        }
                    }
                }, errorListener, activity);
    }
}
