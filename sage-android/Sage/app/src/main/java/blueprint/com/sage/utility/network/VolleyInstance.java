package blueprint.com.sage.utility.network;

import android.content.Context;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;

/**
 * Created by charlesx on 9/26/15.
 * Returns a instance of Volley.
 */
public class VolleyInstance {
    private static VolleyInstance mInstance;
    private Context mContext;
    private RequestQueue mRequestQueue;

    private VolleyInstance(Context context) {
        mContext = context;
        mRequestQueue = getRequestQueue();
    }

    public static synchronized VolleyInstance getInstance(Context context) {
        if (mInstance == null) mInstance = new VolleyInstance(context);
        return mInstance;
    }

    private RequestQueue getRequestQueue() {
        if (mRequestQueue == null) mRequestQueue = Volley.newRequestQueue(mContext);
        return mRequestQueue;
    }

    public void add(Request request) { getRequestQueue().add(request); }
}
