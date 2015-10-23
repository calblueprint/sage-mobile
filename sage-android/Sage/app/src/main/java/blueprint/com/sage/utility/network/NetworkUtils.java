package blueprint.com.sage.utility.network;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import blueprint.com.sage.R;
import blueprint.com.sage.signin.SignInActivity;

/**
 * Created by kelseylam on 10/17/15.
 * General network connection utility functions.
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
}
