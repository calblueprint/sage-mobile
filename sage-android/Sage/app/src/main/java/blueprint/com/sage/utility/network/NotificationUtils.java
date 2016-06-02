package blueprint.com.sage.utility.network;

import android.app.ActivityManager;
import android.content.Context;

import java.util.List;

/**
 * Created by charlesx on 6/2/16.
 */
public class NotificationUtils {

    public static boolean isAppOpen(Context context) {
        ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningTaskInfo> taskInfos = manager.getRunningTasks(1);
    }
}
