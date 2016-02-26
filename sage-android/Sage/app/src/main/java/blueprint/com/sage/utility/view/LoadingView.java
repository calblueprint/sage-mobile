package blueprint.com.sage.utility.view;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.TranslateAnimation;
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

    private TranslateAnimation mUpAnimation;
    private TranslateAnimation mDownAnimation;

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
        inflate(context, R.layout.list_progress_view, this);
        ButterKnife.bind(this);

//        mDownAnimation = AnimationUtils.getYTranslationAnimator();
//        mUpAnimation = AnimationUtils.getYTranslationAnimator();

        initializeAnimators();
    }

    private void initializeAnimators() {
        mCircleOne.setAnimation(getTranslationAnimator(mCircleOne));
        mCircleTwo.setAnimation(getTranslationAnimator(mCircleTwo));
        mCircleThree.setAnimation(getTranslationAnimator(mCircleThree));
    }

    private Animation getTranslationAnimator(View view) {
        mUpAnimation.setAnimationListener(getAnimationListener(view));
        return mUpAnimation;
    }

    private Animation.AnimationListener getAnimationListener(final View view) {
        return new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
                view.setAnimation(mDownAnimation);
                mDownAnimation.start();
            }

            @Override
            public void onAnimationEnd(Animation animation) {}

            @Override
            public void onAnimationRepeat(Animation animation) {}
        };
    }
}

