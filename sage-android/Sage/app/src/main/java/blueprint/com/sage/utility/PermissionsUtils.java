package blueprint.com.sage.utility;

import android.Manifest;
import android.app.Activity;
import android.content.pm.PackageManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;


/**
 * Created by charlesx on 1/21/16.
 */
public class PermissionsUtils {

    public static final int PERMISSION_REQUEST_CODE = 200;

    public static boolean hasLocationPermissions(Activity activity) {
        return hasPermission(activity, Manifest.permission.ACCESS_COARSE_LOCATION) &&
                hasPermission(activity, Manifest.permission.ACCESS_FINE_LOCATION);
    }

    public static boolean hasIOPermissions(Activity activity) {
        return hasPermission(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE);
    }

    public static boolean hasInternetPermissions(Activity activity) {
        return hasPermission(activity, Manifest.permission.INTERNET) &&
                hasPermission(activity, Manifest.permission.ACCESS_NETWORK_STATE);
    }

    private static boolean hasPermission(Activity activity, String permission) {
        return ContextCompat.checkSelfPermission(activity, permission) == PackageManager.PERMISSION_GRANTED;
    }

    public static void requestLocationPermissions(Activity activity) {
        requestPermissions(activity, Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION);
    }

    public static void requestIOPermissions(Activity activity) {
        requestPermissions(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE);
    }

    public static void requestInternetPermissions(Activity activity) {
        requestPermissions(activity, Manifest.permission.INTERNET, Manifest.permission.ACCESS_NETWORK_STATE);
    }

    public static void requestPermissions(Activity activity, String... permissions) {
        ActivityCompat.requestPermissions(activity, permissions, PERMISSION_REQUEST_CODE);
    }
}
