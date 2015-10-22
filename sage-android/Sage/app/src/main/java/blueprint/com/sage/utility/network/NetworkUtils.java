package blueprint.com.sage.utility.network;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import blueprint.com.sage.R;
import blueprint.com.sage.signin.SignInActivity;

/**
 * Created by kelseylam on 10/17/15.
 */
public class NetworkUtils {
    public static boolean isConnectedToInternet(Activity activity) {
        ConnectivityManager connectManager = (ConnectivityManager) activity.getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo activeNetworkInfo = connectManager.getActiveNetworkInfo();
        return activeNetworkInfo != null && activeNetworkInfo.isConnected();
    }

    public static void logoutCurrentUser(Activity activity) {
        SharedPreferences sharedPreferences = activity.getSharedPreferences(activity.getString(R.string.preferences),
                                                                                               Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.remove(activity.getString(R.string.email));
        editor.remove(activity.getString(R.string.auth_token));
        editor.remove(activity.getString(R.string.user));
        editor.remove(activity.getString(R.string.school));
        editor.apply();

        Intent loginIntent = new Intent(activity, SignInActivity.class);
        activity.startActivity(loginIntent);
    }

    public static boolean hasLocationServiceEnabled(Context context) {
        LocationManager manager = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
        boolean hasGps = manager.isProviderEnabled(LocationManager.GPS_PROVIDER);
        boolean hasNetwork = manager.isProviderEnabled(LocationManager.NETWORK_PROVIDER);

        return hasGps || hasNetwork;
    }

    public static boolean isVerifiedUser(Context context, SharedPreferences preferences) {
        return !preferences.getString(context.getString(R.string.email), "").isEmpty() &&
               !preferences.getString(context.getString(R.string.auth_token), "").isEmpty() &&
               // TODO: replace this with getString after Kelsey merges her stuff
               !preferences.getString("user", "").isEmpty() &&
               !preferences.getString("school", "").isEmpty();
    }
}
