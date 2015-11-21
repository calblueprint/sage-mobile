package blueprint.com.sage.utility.view;

import android.app.Activity;
import android.content.Context;
import android.support.v4.app.Fragment;
import android.util.TypedValue;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.ImageView;

import com.squareup.picasso.Picasso;

/**
 * Created by charlesx on 11/3/15.
 */
public class ViewUtils {

    public static int convertFromDpToPx(Context context, int pixel) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,
                pixel,
                context.getResources().getDisplayMetrics());
    }

    public static void loadImage(Activity activity, String url, ImageView imageView) {
        Picasso.with(activity).load(url).into(imageView);
    }

    public static void loadImage(Activity activity, int drawable, ImageView imageView) {
        Picasso.with(activity).load(drawable).into(imageView);
    }

    public static void hideKeyboard(Fragment fragment) {
        View focus = fragment.getActivity().getCurrentFocus();
        if(focus != null) {
            InputMethodManager inputMethodManager =
                    (InputMethodManager) fragment.getActivity().getSystemService(Activity.INPUT_METHOD_SERVICE);
            inputMethodManager.hideSoftInputFromWindow(focus.getWindowToken(), 0);
        }
    }
}
