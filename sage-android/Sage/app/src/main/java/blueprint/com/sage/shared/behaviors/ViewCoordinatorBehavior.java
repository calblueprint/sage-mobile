package blueprint.com.sage.shared.behaviors;

import android.content.Context;
import android.support.design.widget.CoordinatorLayout;
import android.support.design.widget.Snackbar;
import android.util.AttributeSet;
import android.view.View;

/**
 * Created by charlesx on 1/27/16.
 */
public class ViewCoordinatorBehavior extends CoordinatorLayout.Behavior<View> {
    public ViewCoordinatorBehavior(Context context, AttributeSet attrSet) {}

    @Override
    public boolean layoutDependsOn(CoordinatorLayout parent, View child, View dependency) {
        return dependency instanceof Snackbar.SnackbarLayout;
    }

    @Override
    public boolean onDependentViewChanged(CoordinatorLayout parent, View child, View dependency) {
        child.setTranslationY(Math.min(0, dependency.getTranslationY() - dependency.getHeight()));
        return true;
    }
}
