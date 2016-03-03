package blueprint.com.sage.utility.view;

import android.animation.ObjectAnimator;
import android.content.Context;
import android.view.View;
import android.view.animation.Animation;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.interpolators.CustomBounceInterpolator;

/**
 * Created by charlesx on 2/25/16.
 */
public class AnimationUtils {

    public static ObjectAnimator getYTranslationAnimator(View view, int start, int end) {
        return ObjectAnimator.ofFloat(view, "y", start, end);
    }

    public static Animation getBounceSlideUpAnimator(Context context) {
        Animation animation = android.view.animation.AnimationUtils.loadAnimation(context, R.anim.slide_from_top);
        animation.setInterpolator(new CustomBounceInterpolator());
        return animation;
    }
}
