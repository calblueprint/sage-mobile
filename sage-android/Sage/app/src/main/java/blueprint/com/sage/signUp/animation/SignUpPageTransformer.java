package blueprint.com.sage.signUp.animation;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.Log;
import android.util.TypedValue;
import android.view.View;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 10/12/15.
 */
public class SignUpPageTransformer implements ViewPager.PageTransformer {

    private static float mMinAlpha;
    private Context mContext;

    public void transformPage(View view, float position) {
        if (position < -1 || position > 1) {
            // This page is way off-screen to the left/right.
            view.setAlpha(0);
            return;
        }

        mContext = view.getContext();

        TypedValue value = new TypedValue();
        mContext.getResources().getValue(R.dimen.white_dots_alpha, value, true);
        mMinAlpha = value.getFloat();

        int pageWidth = view.getWidth();
        int id = view.getId();

        // Counteract moving motion
//        view.setTranslationX(-position * pageWidth);
//        view.setAlpha(position);

        View dotLayout = view.findViewById(R.id.white_dots_container);
        dotLayout.setTranslationX(-position * pageWidth);

        switch (id) {
            case R.id.sign_up_name_container:
                Log.e("position", "Name position    " + String.valueOf(position));
                transformName(view, position);
                break;
            case R.id.sign_up_email_container:
                Log.e("position", "Email position   " + String.valueOf(position));
                transformEmail(view, position);
                break;
            case R.id.sign_up_school_container:
                Log.e("position", "School position  " + String.valueOf(position));
                transformSchool(view, position);
                break;
            case R.id.sign_up_profile_container:
                Log.e("position", "Profile position " + String.valueOf(position));
                transformProfile(view, position);
                break;
        }
    }

    private void transformName(View view, float position) {
        animateDots(view, 1, position);
    }

    private void transformEmail(View view, float position) {
        animateDots(view, 2, position);
    }

    private void transformSchool(View view, float position) {
        animateDots(view, 3, position);
    }

    private void transformProfile(View view, float position) {
        animateDots(view, 4, position);
    }

    private void animateDots(View view, int dot, float position) {
        String image = "white_dot_" + dot;
        int id = mContext.getResources().getIdentifier(image, "id", mContext.getPackageName());
        View dotView = view.findViewById(id);

        dotView.setAlpha(calculateAlpha(position));
    }

    private float calculateAlpha(float position) {
        return (1- Math.abs(position)) * (1 - mMinAlpha) + mMinAlpha;
    }
}
