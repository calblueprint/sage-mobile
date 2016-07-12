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

    public static void setCheckInSummary(Context context, User user, TextView hoursWeekly, TextView percent, TextView hoursRequired,
                                         ImageView active, ProgressBar progressBar) {
        double hours = user.getUserSemester().getTotalTime() / 60.0;

        hoursWeekly.setText(user.getHoursString());
        percent.setText(context.getResources().getString(R.string.check_in_percent,
                (int) (hours / user.getUserSemester().getHoursRequired() * 100)));

        if (user.getUserSemester().isActive()) {
            hoursRequired.setText(String.format(context.getResources().getString(R.string.check_in_hours_required),
                    hours, user.getUserSemester().getHoursRequired()));
            active.setBackground(context.getResources().getDrawable(R.drawable.ic_done_white));
        } else {
            hoursRequired.setText(context.getResources().getString(R.string.check_in_inactive));
            active.setBackground(context.getResources().getDrawable(R.drawable.ic_flag_black_48dp));
        }

        if (user.getUserSemester().isCompleted()) {
            ViewUtils.changeTint(progressBar.getProgressDrawable(), context, R.color.green500);
        } else {
            ViewUtils.changeTint(progressBar.getProgressDrawable(), context, R.color.red500);
        }

        int progress;
        if (user.getUserSemester().getHoursRequired() == 0) {
            progress = 75;
        } else {
            double num = hours * 1.0 / user.getUserSemester().getHoursRequired() * 1.0 * 100.0 * 3.0 /4.0;
            progress = (int) num;
        }
        progressBar.setProgress(progress);
    }
}
