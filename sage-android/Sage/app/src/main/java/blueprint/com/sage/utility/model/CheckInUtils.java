package blueprint.com.sage.utility.model;

import android.content.Context;
import android.content.SharedPreferences;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.interfaces.BaseInterface;

/**
 * Created by charlesx on 1/14/16.
 */
public class CheckInUtils {
    public static boolean hasPreviousRequest(Context context, BaseInterface baseInterface) {
        return hasPreviousRequest(context, baseInterface.getSharedPreferences(), baseInterface.getUser());
    }

    public static boolean hasPreviousRequest(Context context, SharedPreferences preferences, User user) {
        return !preferences.getString(context.getString(R.string.check_in_start_time, user.getId()), "").isEmpty();
    }

    public static void resetCheckIn(Context context, BaseInterface baseInterface) {
        resetCheckIn(context, baseInterface.getSharedPreferences(), baseInterface.getUser());
    }

    public static void resetCheckIn(Context context, SharedPreferences preferences, User user) {
        preferences.edit()
                .remove(context.getString(R.string.check_in_start_time, user.getId()))
                .remove(context.getString(R.string.check_in_recent_seconds, user.getId()))
                .remove(context.getString(R.string.check_in_total_seconds, user.getId()))
                .remove(context.getString(R.string.check_in_end_time, user.getId()))
                .apply();
    }
}
