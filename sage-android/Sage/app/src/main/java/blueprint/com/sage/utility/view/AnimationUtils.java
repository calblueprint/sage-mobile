package blueprint.com.sage.utility.view;

import android.view.animation.Interpolator;
import android.view.animation.TranslateAnimation;

/**
 * Created by charlesx on 2/25/16.
 */
public class AnimationUtils {

    public static final int Y_DURATION = 500;

    public static TranslateAnimation getYTranslationAnimator(int start, int end, Interpolator interpolator) {
        TranslateAnimation animation = new TranslateAnimation(0, 0, start, end);
        animation.setDuration(Y_DURATION);
        animation.setInterpolator(interpolator);
        return animation;
    }
}
