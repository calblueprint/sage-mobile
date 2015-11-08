package blueprint.com.sage.utility.view;

import android.app.Activity;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;

/**
 * Created by charlesx on 10/12/15.
 * Some Fragment Utilities
 */
public class FragUtil {
    public static void replace(int id, Fragment fragment, FragmentActivity activity) {
        FragmentTransaction transaction = activity.getSupportFragmentManager().beginTransaction();
        transaction.replace(id, fragment).commit();
    }

    public static void replaceBackStack(int id, Fragment fragment, FragmentActivity activity) {
        FragmentTransaction transaction = activity.getSupportFragmentManager().beginTransaction();
        transaction.replace(id, fragment).addToBackStack(null).commit();
    }
}
