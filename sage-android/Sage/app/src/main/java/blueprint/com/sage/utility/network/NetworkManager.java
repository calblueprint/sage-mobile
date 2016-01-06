package blueprint.com.sage.utility.network;

import android.content.Context;

import com.android.volley.RequestQueue;
import com.android.volley.toolbox.Volley;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

/*
Singleton Request Handler to interface with Network.
 */
public class NetworkManager {
    /**
     * An object to handle API calls at the HTTP request level.
     */
    private static NetworkManager mInstance;
    private RequestQueue mRequestQueue;
    private static Context mContext;

    private static ObjectMapper mObjectMapper;

    /**
     * Returns a RequestHandler by assigning CONTEXT, an applicaiton
     * context set by the caller, to a RequestQueue object, which
     * handles background threading of HTTP requests.
     */
    private NetworkManager(Context context) {
        mContext = context;
        mRequestQueue = Volley.newRequestQueue(mContext);
        getObjectMapper();
    }

    /**
     * Ensures singleton networkManager that survives the duration of the Application
     * Lifecycle.
     *
     * @param context
     * @return
     */
    public static synchronized NetworkManager getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new NetworkManager(context);
        }
        return mInstance;
    }

    // Request Queue
    public RequestQueue getRequestQueue() { return mRequestQueue; }

    // Object Mapper
    public ObjectMapper getObjectMapper() {
        if (mObjectMapper == null) {
            mObjectMapper = createObjectMapper();
        }
        return mObjectMapper;
    }

    public ObjectMapper createObjectMapper() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
        objectMapper.setPropertyNamingStrategy(PropertyNamingStrategy.CAMEL_CASE_TO_LOWER_CASE_WITH_UNDERSCORES);
        return objectMapper;
    }
}
