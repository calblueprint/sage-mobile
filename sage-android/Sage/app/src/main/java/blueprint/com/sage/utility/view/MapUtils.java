package blueprint.com.sage.utility.view;

import android.app.Activity;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.util.Log;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapView;
import com.google.android.gms.maps.Projection;
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
    public final static int DISTANCE = 200;
    public final static int RADIUS = 50; /* 50 meters */
    public final static float DEFAULT_LONG = -122.26f;
    public final static float DEFAULT_LAT = 37.87f;
    public final static int SW_LAT = 37;
    public final static int SW_LNG = -123;
    public final static int NE_LAT = 38;
    public final static int NE_LNG = -122;

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

    public static MarkerOptions getMarkerOptions(LatLng latLng, Activity activity) {
        return new MarkerOptions().position(latLng)
                .icon(BitmapDescriptorFactory.fromResource(R.drawable.ic_location_on_blue_48dp));
    }

    public static CircleOptions getCircleOptions(Activity activity, LatLng latLng, int radius) {
        return new CircleOptions()
                    .center(latLng)
                    .radius(radius)
                    .strokeWidth(5.0f)
                    .strokeColor(ViewUtils.getColor(activity, R.color.transparent))
                    .fillColor(ViewUtils.getColor(activity, R.color.map_circle_fill));
    }

    public static int convertRadius(MapView mapView, GoogleMap map, int radius) {
        int newRadius;
        int width = mapView.getMeasuredWidth();
        Projection projection = map.getProjection();
        LatLng left = projection.getVisibleRegion().nearLeft;
        LatLng right = projection.getVisibleRegion().nearRight;
        float[] dist = new float[1];
        Location.distanceBetween(left.latitude, left.longitude, right.latitude, right.longitude, dist);
        newRadius = Math.round(width / dist[0] * radius);
        return newRadius;
    }
}
