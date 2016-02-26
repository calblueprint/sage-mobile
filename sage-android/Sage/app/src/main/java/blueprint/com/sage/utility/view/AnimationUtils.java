package blueprint.com.sage.utility.view;

import android.animation.ObjectAnimator;
import android.view.View;

/**
 * Created by charlesx on 2/25/16.
 */
public class AnimationUtils {

    public static ObjectAnimator getYTranslationAnimator(View view, int start, int end) {
        return ObjectAnimator.ofFloat(view, "y", start, end);
    }
}
