package blueprint.com.sage.utility.view;

import android.app.Activity;
import android.content.Intent;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 10/12/15.
 * Some Fragment Utilities
 */
public class FragUtils {

    /**
     * Activity Constants (for onActivityResult)
     */
    public static final int START_SEMESTER_REQUEST_CODE = 100;
    public static final int FINISH_SEMESTER_REQUEST_CODE = 101;
    public static final int CREATE_ANNOUNCEMENT_REQUEST_CODE = 102;
    public static final int SHOW_ANNOUNCEMENT_REQUEST_CODE = 103;
    public static final int PAUSE_SEMESTER_REQUEST_CODE = 104;

    public static void replace(int id, Fragment fragment, FragmentActivity activity) {
        FragmentTransaction transaction = activity.getSupportFragmentManager().beginTransaction();
        transaction.replace(id, fragment).commit();
    }

    public static void replaceBackStack(int id, Fragment fragment, FragmentActivity activity) {
        FragmentTransaction transaction = activity.getSupportFragmentManager().beginTransaction();
        transaction.setCustomAnimations(R.anim.slide_in_right, R.anim.slide_out_left, R.anim.slide_in_left, R.anim.slide_out_right);
        transaction.replace(id, fragment).addToBackStack(null).commit();
    }

    public static void popBackStack(Fragment fragment) {
        ViewUtils.hideKeyboard(fragment);
        fragment.getFragmentManager().popBackStack();
    }

    public static void popBackStack(FragmentActivity activity) {
        activity.getSupportFragmentManager().popBackStack();
    }

    public static void startActivityBackStack(Activity activity, Class<?> cls) {
        Intent intent = new Intent(activity, cls);
        startActivityBackStack(activity, intent);
    }

    public static void startActivityBackStack(Activity activity, Intent intent) {
        activity.startActivity(intent);
        activity.overridePendingTransition(0, 0);
    }

    public static void startActivity(Activity activity, Class<?> cls) {
        Intent intent = new Intent(activity, cls);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK |
                Intent.FLAG_ACTIVITY_CLEAR_TASK |
                Intent.FLAG_ACTIVITY_NO_ANIMATION);

        activity.startActivity(intent);
        activity.overridePendingTransition(0, 0);
    }

    public static void startActivityForResultActivity(Activity activity, Class<?> cls, int requestCode) {
        Intent intent = new Intent(activity, cls);
        activity.startActivityForResult(intent, requestCode);
        activity.overridePendingTransition(0, 0);
    }

    public static void startActivityForResultFragment(Activity activity, Fragment fragment, Class<?> cls, int requestCode) {
        Intent intent = new Intent(activity, cls);
        fragment.startActivityForResult(intent, requestCode);
        activity.overridePendingTransition(0, 0);
    }

    public static void startActivityForResultFragment(Activity activity, Fragment fragment, Class<?> cls, int requestCode, Intent intent) {
        fragment.startActivityForResult(intent, requestCode);
        activity.overridePendingTransition(0, 0);
    }
}
