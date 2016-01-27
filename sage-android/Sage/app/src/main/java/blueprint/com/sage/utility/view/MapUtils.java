package blueprint.com.sage.utility.view;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.location.Address;
import android.location.Geocoder;
import android.util.Log;

import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.CircleOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;
import com.google.android.gms.maps.model.MarkerOptions;

import java.util.List;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 11/17/15.
 */
public class MapUtils {

    public final static int ZOOM = 16;

    // Radius of circle boundary of school
    public final static int DISTANCE = Integer.MAX_VALUE;
    public final static int RADIUS = 50; /* 50 meters */
    public final static float DEFAULT_LONG = -122.26f;
    public final static float DEFAULT_LAT = 37.87f;

    public static LatLngBounds createBounds(int swLat, int swLng, int neLat, int neLng) {
        return new LatLngBounds(new LatLng(swLat, swLng), new LatLng(neLat, neLng));
    }

    public static LatLng getLatLngFromAddress(Activity activity, String address) {
        Geocoder geocoder = new Geocoder(activity);

        List<Address> addresses;

        try {
            addresses = geocoder.getFromLocationName(address, 1);

            if (addresses == null || addresses.size() == 0)
                return null;

            Address location = addresses.get(0);
            return new LatLng(location.getLatitude(), location.getLongitude());
        } catch(Exception e) {
            Log.e(MapUtils.class.toString(), e.toString());
        }

        return null;
    }

    public static boolean hasPreviousRequest(Context context, SharedPreferences preferences) {
        return !preferences.getString(context.getString(R.string.check_in_start_time), "").isEmpty();
    }

    public static MarkerOptions getMarkerOptions(LatLng latLng) {
        return new MarkerOptions().position(latLng)
                .icon(BitmapDescriptorFactory.fromResource(R.drawable.ic_pin_blue));
    }

    public static CircleOptions getCircleOptions(Activity activity, LatLng latLng, int radius) {
        return new CircleOptions()
                .center(latLng)
                .radius(radius)
                .strokeWidth(5.0f)
                .strokeColor(ViewUtils.getColor(activity, R.color.map_circle_stroke))
                .fillColor(ViewUtils.getColor(activity, R.color.map_circle_fill));
    }
}
