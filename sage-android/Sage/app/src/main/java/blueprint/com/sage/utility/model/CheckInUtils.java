package blueprint.com.sage.utility.model;

import android.app.Activity;
import android.content.SharedPreferences;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 1/14/16.
 */
public class CheckInUtils {
    public static void resetCheckIn(Activity activity, SharedPreferences preferences) {
        preferences.edit()
                .remove(activity.getString(R.string.check_in_start_time))
                .remove(activity.getString(R.string.check_in_recent_seconds))
                .remove(activity.getString(R.string.check_in_total_seconds))
                .remove(activity.getString(R.string.check_in_end_time))
                .apply();
    }
}
