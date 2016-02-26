package blueprint.com.sage.utility.view;

import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.Animation;
import android.view.animation.Interpolator;
import android.view.animation.TranslateAnimation;

/**
 * Created by charlesx on 2/25/16.
 */
public class AnimationUtils {

    public static final int Y_DURATION = 500;

    public static TranslateAnimation getUpDownAnimator(final View view, int start, int end) {
        TranslateAnimation toTop = getYTranslationAnimator(start, end, new AccelerateDecelerateInterpolator());
        final TranslateAnimation toBottom = getYTranslationAnimator(end, start, new AccelerateDecelerateInterpolator());
        toTop.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                view.setAnimation(toBottom);
                toBottom.start();
            }

            @Override
            public void onAnimationEnd(Animation animation) {}

            @Override
            public void onAnimationRepeat(Animation animation) {}
        });

        return toTop;
    }

    public static TranslateAnimation getYTranslationAnimator(int start, int end, Interpolator interpolator) {
        TranslateAnimation animation = new TranslateAnimation(0, 0, start, end);
        animation.setDuration(Y_DURATION);
        animation.setInterpolator(interpolator);
        return animation;
    }
}
