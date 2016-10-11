package blueprint.com.sage.network.announcements;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.Response;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.json.JSONObject;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.network.BaseRequest;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by kelseylam on 11/12/15.
 */
public class CreateAnnouncementRequest extends BaseRequest {

    public CreateAnnouncementRequest(final Activity activity, Announcement announcement,
                                    final Response.Listener<Announcement> listener, final Response.Listener<APIError> errorListener) {
        super(Request.Method.POST, makeUrl(null, "admin", "announcements"), convertToParams(announcement, "announcement", activity),
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject jsonObject) {
                        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
                        try {
                            String string = jsonObject.getString("announcement");
                            Announcement announcement = mapper.readValue(string, new TypeReference<Announcement>() {});
                            listener.onResponse(announcement);
                        } catch (Exception e) {
                            Log.e(getClass().toString(), e.toString());
                        }
                    }
                }, new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {
                        errorListener.onResponse(error);
                    }
                }, activity);
    }
}
