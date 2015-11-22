package blueprint.com.sage.utility.view;

import android.app.Activity;
import android.location.Address;
import android.location.Geocoder;
import android.util.Log;

import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

import java.util.List;

/**
 * Created by charlesx on 11/17/15.
 */
public class MapUtils {

    public final static int ZOOM = 16;

    // Radius of circle boundary of school (int meters)
    public final static int DISTANCE = 100000;
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
}
