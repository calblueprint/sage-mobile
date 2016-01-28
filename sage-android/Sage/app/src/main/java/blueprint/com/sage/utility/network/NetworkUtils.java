package blueprint.com.sage.utility.network;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.location.LocationManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.util.Log;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import blueprint.com.sage.R;
import blueprint.com.sage.main.MainActivity;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.models.User;
import blueprint.com.sage.signIn.SignInActivity;
import blueprint.com.sage.signUp.UnverifiedActivity;
import blueprint.com.sage.utility.view.FragUtils;

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

    public static void loginUser(Session session, Activity activity) throws Exception {
        SharedPreferences sharedPreferences = activity.getSharedPreferences(activity.getString(R.string.preferences),
                Context.MODE_PRIVATE);

        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
        String schoolString = mapper.writeValueAsString(session.getSchool());

        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(activity.getString(R.string.email), session.getEmail());
        editor.putString(activity.getString(R.string.auth_token), session.getAuthenticationToken());
        editor.putString(activity.getString(R.string.school), schoolString);
        editor.apply();

        setUser(activity, session.getUser());

        loginUser(activity);
    }

    public static void setUser(Activity activity, User user) throws Exception {
        SharedPreferences sharedPreferences = activity.getSharedPreferences(activity.getString(R.string.preferences),
                Context.MODE_PRIVATE);

        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
        String userString = mapper.writeValueAsString(user);

        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(activity.getString(R.string.user), userString).apply();
    }

    public static void loginUser(Activity activity) throws Exception {
        Intent intent;

        SharedPreferences sharedPreferences =
                activity.getSharedPreferences(activity.getString(R.string.preferences), Context.MODE_PRIVATE);

        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
        String userString = sharedPreferences.getString(activity.getString(R.string.user), "");
        User user = mapper.readValue(userString, new TypeReference<User>() {});

        if (user.isVerified()) {
            intent = new Intent(activity, MainActivity.class);
//            intent = new Intent(activity, CheckInActivity.class);
        } else {
            intent = new Intent(activity, UnverifiedActivity.class);
        }

        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
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

        FragUtils.startActivity(activity, SignInActivity.class);
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
               !preferences.getString(context.getString(R.string.user), "").isEmpty() &&
               !preferences.getString(context.getString(R.string.school), "").isEmpty();
    }

    public static void writeAsPreferences(Activity activity, String key, Object object) {
        SharedPreferences sharedPreferences = 
                activity.getSharedPreferences(activity.getString(R.string.preferences), Context.MODE_PRIVATE);

        String objectString = writeAsString(activity, object);
        if (objectString != null) {
            SharedPreferences.Editor editor = sharedPreferences.edit();
            editor.putString(key, objectString);
            editor.apply();
        }
    }

    public static String writeAsString(Activity activity, Object object) {
        String objectString = null;
        try {
            ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
            objectString = mapper.writeValueAsString(object);
        } catch(Exception e) {
            Log.e(NetworkUtils.class.toString(), e.toString());
        }
        return objectString;
    }

    public static <T> T writeAsObject(Activity activity, String objectString, TypeReference<T> typeReference) {
        ObjectMapper mapper = NetworkManager.getInstance(activity).getObjectMapper();
        try {
            return mapper.readValue(objectString, typeReference);
        } catch(Exception e) {
            Log.e(NetworkUtils.class.toString(), e.toString());
        }
        return null;
    }
}
