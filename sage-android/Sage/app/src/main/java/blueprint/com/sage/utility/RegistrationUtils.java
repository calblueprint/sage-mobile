package blueprint.com.sage.utility;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;

/**
 * Created by charlesx on 4/17/16.
 */
public class RegistrationUtils {

    public static int DEVICE_TYPE = 0;

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
}
