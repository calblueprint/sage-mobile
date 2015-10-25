package blueprint.com.sage.utility.network;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import blueprint.com.sage.R;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.signIn.SignInActivity;
import blueprint.com.sage.signUp.UnverifiedActivity;

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

    public static void loginUser(Session session, Activity activity) throws JsonProcessingException {
        SharedPreferences sharedPreferences = activity.getSharedPreferences(activity.getString(R.string.preferences),
                Context.MODE_PRIVATE);

        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();

        String userString = mapper.writeValueAsString(session.getUser());
        String schoolString = mapper.writeValueAsString(session.getSchool());

        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(activity.getString(R.string.email), session.getEmail());
        editor.putString(activity.getString(R.string.auth_token), session.getAuthenticationToken());
        editor.putString(activity.getString(R.string.user), userString);
        editor.putString(activity.getString(R.string.school), schoolString);
        editor.apply();

        Intent intent;
        // TODO: Add this after we merge in the check in event
//        if (session.getUser().isVerified()) {
//            // Sign in to check in
//        } else {
//            intent = new Intent(activity, UnverifiedActivity.class);
//        }
        intent = new Intent(activity, UnverifiedActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        activity.startActivity(intent);
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
        loginIntent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        activity.startActivity(loginIntent);
    }
}
