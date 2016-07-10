package blueprint.com.sage.utility.view;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.support.v4.app.Fragment;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
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

    @TargetApi(21)
    public static void setStatusBarColor(Activity activity, int color) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
            activity.getWindow().setStatusBarColor(ContextCompat.getColor(activity, color));
    }

    public static void setToolBarElevation(Activity activity, float elevation) {
        ActionBar actionBar = ((AppCompatActivity) activity).getSupportActionBar();
        if (actionBar != null)
            actionBar.setElevation(elevation);
    }

    @TargetApi(21)
    public static void setElevation(View view, float elevation) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP)
            view.setElevation(elevation);
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

    @SuppressWarnings("deprecation")
    public static int getColor(Context context, int color) {
        return ContextCompat.getColor(context, color);
    }

    public static Drawable getDrawable(Context context, int drawable) {
        return ContextCompat.getDrawable(context, drawable);
    }
}
