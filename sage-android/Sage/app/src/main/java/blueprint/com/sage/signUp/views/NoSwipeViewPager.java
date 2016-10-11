package blueprint.com.sage.signUp.views;

import android.content.Context;
import android.content.res.TypedArray;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.util.Log;
import android.view.MotionEvent;
import android.view.animation.Interpolator;
import android.widget.Scroller;

import java.lang.reflect.Field;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 10/24/15.
 * Creates a viewpager that isn't swipeable.
 */
public class NoSwipeViewPager extends ViewPager {

    private CustomScroller mScroller;
    private float mScrollFactor;

    public NoSwipeViewPager(Context context) {
        super(context);
    }

    public NoSwipeViewPager(Context context, AttributeSet attrSet) {
        super(context, attrSet);
        initializeView(context, attrSet);
    }

    private void initializeView(Context context, AttributeSet attrs) {

        TypedArray typedArray =
                context.getTheme().obtainStyledAttributes(attrs, R.styleable.NoSwipeViewPager, 0, 0);

        mScrollFactor = typedArray.getFloat(R.styleable.NoSwipeViewPager_scrollFactor, 1.0f);

        try {
            Field scroller = ViewPager.class.getDeclaredField("mScroller");
            scroller.setAccessible(true);
            Field interpolator = ViewPager.class.getDeclaredField("sInterpolator");
            interpolator.setAccessible(true);

            mScroller = new CustomScroller(getContext(),
                    (Interpolator) interpolator.get(null));
            scroller.set(this, mScroller);

            mScroller.setScrollFactor(mScrollFactor);
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
    }

    public void setScrollFactor(float scrollFactor) { mScrollFactor = scrollFactor; }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent event) { return false; }

    @Override
    public boolean onTouchEvent(MotionEvent event) { return false; }

    public void setScrollDurationFactor(float scrollFactor) {
        mScroller.setScrollFactor(scrollFactor);
    }

    private static class CustomScroller extends Scroller {

        private float mScrollFactor;

        public CustomScroller(Context context, Interpolator interpolator) {
            super(context, interpolator);
        }

        public void setScrollFactor(float scrollFactor) { mScrollFactor = scrollFactor; }

        @Override
        public void startScroll(int startX, int startY, int dx, int dy, int duration) {
            super.startScroll(startX, startY, dx, dy, (int) (duration * mScrollFactor));
        }
    }
}
