package blueprint.com.sage.utility.network;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v4.util.LruCache;
import android.util.Log;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.ImageRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;

/*
Singleton Request Handler to interface with Network.
 */
public class NetworkManager {
    /**
     * An object to handle API calls at the HTTP request level.
     */
    private static NetworkManager mInstance;
    private RequestQueue mRequestQueue;
    private ImageLoader mImageLoader;
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

        mImageLoader = new ImageLoader(mRequestQueue,
                new ImageLoader.ImageCache() {
                    private final LruCache<String, Bitmap>
                            cache = new LruCache<String, Bitmap>(20);

                    @Override
                    public Bitmap getBitmap(String url) {
                        return cache.get(url);
                    }

                    @Override
                    public void putBitmap(String url, Bitmap bitmap) {
                        ByteArrayOutputStream out = new ByteArrayOutputStream();
                        bitmap.compress(Bitmap.CompressFormat.JPEG, 50, out);
                        bitmap = BitmapFactory.decodeStream(new ByteArrayInputStream(out.toByteArray()));
                        cache.put(url, bitmap);
                    }
                });
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

    /**
     * Returns an Image Loader for populating Views with images fetched from a URL.
     *
     * @return
     */
    public ImageLoader getImageLoader() {
        return mImageLoader;
    }

    public void imageRequest(String url, final Response.Listener<Bitmap> listener) {
        ImageRequest request = new ImageRequest(url,
                new Response.Listener<Bitmap>() {
                    @Override
                    public void onResponse(Bitmap bitmap) {
                        listener.onResponse(bitmap);
                    }
                }, 0, 0, null,
                new Response.ErrorListener() {
                    public void onErrorResponse(VolleyError error) {
                        Log.d("Volley Error", error.toString());
                    }
                });
        mRequestQueue.add(request);
    }

    public String stringRequest(String url) {
        final String[] Stringresponse = new String[1];

        StringRequest request = new StringRequest(Request.Method.GET, url,
                new Response.Listener<String>() {
                    @Override
                    public void onResponse(String response) {
                        Log.e("INTERNET RESPONSE", "Response is: " + response.substring(0, 500));
                        Stringresponse[0] = response;
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                Log.e("INTERNET RESPONSE", "IT DIDN't WORK!");
            }
        });
        mRequestQueue.add(request);
        return Stringresponse[0];
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

    public void setObjectMapper(ObjectMapper objectMapper) {
        mObjectMapper = objectMapper;
    }

    public ObjectMapper createObjectMapper() {
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.setPropertyNamingStrategy(PropertyNamingStrategy.CAMEL_CASE_TO_LOWER_CASE_WITH_UNDERSCORES);
        return objectMapper;
    }
}
