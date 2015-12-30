package blueprint.com.sage.signUp.views;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.MotionEvent;

/**
 * Created by charlesx on 10/24/15.
 * Creates a viewpager that isn't swipeable.
 */
public class NoSwipeViewPager extends ViewPager {
    public NoSwipeViewPager(Context context) { super(context); }

    public NoSwipeViewPager(Context context, AttributeSet attrSet) { super(context, attrSet); }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent event) { return false; }

    @Override
    public boolean onTouchEvent(MotionEvent event) { return false; }
}
