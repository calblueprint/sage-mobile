package blueprint.com.sage.network.announcements;

import android.app.Activity;
import android.util.Log;

import com.android.volley.Response;
import com.android.volley.VolleyError;

import org.json.JSONObject;

import blueprint.com.sage.network.BaseRequest;

/**
 * Created by kelseylam on 10/10/15.
 */
public class AnnouncementsIndexRequest extends BaseRequest {
    public BaseRequest(int requestType, String url, JSONObject params,
                       Response.Listener onSuccess, Activity activity) {
        this(requestType, url, params, onSuccess, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError volleyError) {
                Log.e("BaseRequest#constructor", volleyError.toString());
            }
        }, activity);
    }
}
