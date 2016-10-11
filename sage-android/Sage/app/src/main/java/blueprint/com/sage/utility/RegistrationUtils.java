package blueprint.com.sage.utility;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import blueprint.com.sage.R;
import blueprint.com.sage.utility.network.NetworkUtils;

/**
 * Created by charlesx on 4/17/16.
 */
public class RegistrationUtils {

    public static int DEVICE_TYPE = 0;
    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private static final String TAG = "Registration";
    private static boolean mIsReceiverRegistered = false;

    /**
     * Gets the current registration ID for application on GCM service.
     * If result is empty, the app needs to register.
     *
     * @return registration ID, or empty string if there is no existing
     *         registration ID.
     */
    public static String getRegistrationId(Context context) {
        SharedPreferences sharedPreferences = NetworkUtils.getSharedPreferences(context);
        String registrationId = sharedPreferences.getString(context.getString(R.string.registration_token), "none");

        if (registrationId.equals("none")) {
            Log.i(TAG, "Registration not found.");
            return "";
        }

        int currentVersion = RegistrationUtils.getAppVersion(context);
        int appVersion = sharedPreferences.getInt(context.getString(R.string.app_version), Integer.MIN_VALUE);
        if (appVersion != currentVersion) {
            Log.i(TAG, "App version changed.");
            sharedPreferences.edit().putInt("app_version", currentVersion).apply();
            return "";
        }
        return registrationId;
    }

    /**
     * Gets the current app version
     * @param context Context to get information from
     * @return Version of the application
     */
    public static int getAppVersion(Context context) {
        try {
            PackageInfo packageInfo = context.getPackageManager()
                    .getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            // should never happen
            throw new RuntimeException("Could not get package name: " + e);
        }
    }

    public static boolean checkPlayServices(Activity activity) {
        GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = apiAvailability.isGooglePlayServicesAvailable(activity);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (apiAvailability.isUserResolvableError(resultCode)) {
                apiAvailability.getErrorDialog(activity, resultCode, PLAY_SERVICES_RESOLUTION_REQUEST)
                        .show();
            } else {
                Log.i(TAG, "This device is not supported.");
                activity.finish();
            }
            return false;
        }
        return true;
    }

    public static void registerReceivers(Context context, BroadcastReceiver broadcastReceiver) {
        if (!mIsReceiverRegistered) {
            LocalBroadcastManager.getInstance(context).registerReceiver(broadcastReceiver,
                    new IntentFilter(context.getString(R.string.registration_complete)));
            mIsReceiverRegistered = true;
        }
    }

    public static void unregisterReceivers(Context context, BroadcastReceiver broadcastReceiver) {
        LocalBroadcastManager.getInstance(context).unregisterReceiver(broadcastReceiver);
        mIsReceiverRegistered = false;
    }
}
