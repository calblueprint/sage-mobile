package blueprint.com.sage.utility.model;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

import blueprint.com.sage.R;

/**
 * Created by kelseylam on 4/20/16.
 */
public class SessionUtils {
    public static void updateRequestCount(Activity activity, int diff, int resource) {
        SharedPreferences sharedPreferences = activity.getSharedPreferences(activity.getString(R.string.preferences),
                Context.MODE_PRIVATE);

        int count = Integer.valueOf(sharedPreferences.getString(activity.getString(resource),
                activity.getString(R.string.admin_default_zero)));

        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putString(activity.getString(resource), String.valueOf(count + diff)).apply();
    }
}
