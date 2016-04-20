package blueprint.com.sage.utility.view;

import android.animation.Animator;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.widget.LinearLayout;

import blueprint.com.sage.R;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 2/20/16.
 */
public class LoadingView extends LinearLayout {

    @Bind(R.id.list_progress_circle_1) View mCircleOne;
    @Bind(R.id.list_progress_circle_2) View mCircleTwo;
    @Bind(R.id.list_progress_circle_3) View mCircleThree;

    private AnimatorSet mCircleOneAnimationSet;
    private AnimatorSet mCircleTwoAnimationSet;
    private AnimatorSet mCircleThreeAnimationSet;

    private Drawable mCircleDrawable;

    public LoadingView(Context context) {
        super(context);
    }

    public LoadingView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        initializeViews(context, attributeSet);
    }

    public LoadingView(Context context, AttributeSet attributeSet, int defStyle) {
        super(context, attributeSet, defStyle);
        initializeViews(context, attributeSet);
    }

    private void initializeViews(Context context, AttributeSet attributeSet) {
        inflate(context, R.layout.loading_view, this);
        ButterKnife.bind(this);

        TypedArray attributes =
                context.getTheme().obtainStyledAttributes(attributeSet, R.styleable.LoadingView, 0, 0);

        mCircleDrawable = attributes.getDrawable(R.styleable.LoadingView_circleDrawable);

        if (mCircleDrawable == null) {
            mCircleDrawable = getContext().getDrawable(R.drawable.list_progress_circle);
        }

        mCircleOne.setBackground(mCircleDrawable);
        mCircleTwo.setBackground(mCircleDrawable);
        mCircleThree.setBackground(mCircleDrawable);

        setGravity(Gravity.BOTTOM | Gravity.CENTER);
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        super.onLayout(changed, l, t, r, b);
        initializeAnimators();
    }

    private void initializeAnimators() {
        if (hasSetAnimations())
            return;

        mCircleOneAnimationSet = getAnimatorSet(mCircleOne);
        mCircleTwoAnimationSet = getAnimatorSet(mCircleTwo);
        mCircleThreeAnimationSet = getAnimatorSet(mCircleThree);

        mCircleTwoAnimationSet.setStartDelay(100);
        mCircleThreeAnimationSet.setStartDelay(200);

        AnimatorSet animatorSet = new AnimatorSet();
        animatorSet.playTogether(mCircleOneAnimationSet, mCircleTwoAnimationSet, mCircleThreeAnimationSet);
        animatorSet.start();
    }

    private boolean hasSetAnimations() {
        return mCircleOneAnimationSet != null && mCircleTwoAnimationSet != null && mCircleThreeAnimationSet != null;
    }

    private ObjectAnimator getUpAnimator(View view) {
        return getTranslateAnimator(view, getHeight() - getPaddingBottom() - view.getHeight(), getPaddingTop());
    }

    private ObjectAnimator getDownAnimator(View view) {
        return getTranslateAnimator(view, getPaddingTop(), getHeight() - getPaddingBottom() - view.getHeight());
    }

    private ObjectAnimator getTranslateAnimator(View view, int start, int end) {
        return AnimationUtils.getYTranslationAnimator(view, start, end);
    }

    private AnimatorSet getAnimatorSet(View view) {
        AnimatorSet set = new AnimatorSet();
        set.setInterpolator(new AccelerateDecelerateInterpolator());
        set.play(getUpAnimator(view)).before(getDownAnimator(view));
        set.setDuration(500);
        set.setInterpolator(new AccelerateDecelerateInterpolator());
        set.addListener(getAnimationListener(set));

        return set;
    }

    private Animator.AnimatorListener getAnimationListener(final AnimatorSet set) {
        return new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animator) {}

            @Override
            public void onAnimationEnd(Animator animator) {
                set.setStartDelay(0);
                set.start();
            }

            @Override
            public void onAnimationCancel(Animator animator) {}

            @Override
            public void onAnimationRepeat(Animator animator) {}
        };
    }
}

