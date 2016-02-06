package blueprint.com.sage.shared.views;

import android.animation.Animator;
import android.animation.ObjectAnimator;
import android.animation.ValueAnimator;
import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.util.AttributeSet;
import android.view.View;

/**
 * Created by charlesx on 11/5/15.
 * A empty recycleview
 */
public class RecycleViewEmpty extends RecyclerView {

    private int ANIMATION_DURATION = 300;
    private AdapterDataObserver mObserver;

    private View mEmptyView;

    public RecycleViewEmpty(Context context) {
        super(context);
        initView();
    }

    public RecycleViewEmpty(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        initView();
    }

    public RecycleViewEmpty(Context context, AttributeSet attributeSet, int defStyleAttr) {
        super(context, attributeSet, defStyleAttr);
        initView();
    }

    @Override
    public void setAdapter(Adapter adapter) {
        super.setAdapter(adapter);

        if (adapter != null)
            adapter.registerAdapterDataObserver(mObserver);

        refreshLayout();
    }

    private void initView() {
        mObserver = new AdapterDataObserver() {
            @Override
            public void onChanged() {
                super.onChanged();
                refreshLayout();
            }

            @Override
            public void onItemRangeInserted(int positionStart, int itemCount) {
                super.onItemRangeInserted(positionStart, itemCount);
                refreshLayout();
            }

            @Override
            public void onItemRangeRemoved(int positionStart, int itemCount) {
                super.onItemRangeRemoved(positionStart, itemCount);
                refreshLayout();
            }
        };

    }

    public void setEmptyView(View view) {
        mEmptyView = view;
        refreshLayout();
    }

    private void refreshLayout() {
        Adapter adapter = getAdapter();

        if (mEmptyView == null)
            toggleRecyclerView(true);

        if (adapter == null) {
            showRecyclerView();
        } else {
            toggleRecyclerView(adapter.getItemCount() > 0);
        }
    }

    private void toggleRecyclerView(boolean showRecyclerView) {
        if (showRecyclerView && getVisibility() == View.GONE) {
            showRecyclerView();
        } else if (mEmptyView != null && mEmptyView.getVisibility() == View.GONE && !showRecyclerView) {
            showEmptyView();
        }
    }

    private void showRecyclerView() {
        ValueAnimator fadeIn = getObjectAnimator(this, 0, 1).setDuration(ANIMATION_DURATION);
        fadeIn.addListener(getAnimationListener(this, View.VISIBLE));
        fadeIn.start();

        if (mEmptyView != null) {
            ValueAnimator fadeOut = getObjectAnimator(mEmptyView, 1, 0).setDuration(ANIMATION_DURATION);
            fadeOut.addListener(getAnimationListener(mEmptyView, View.GONE));
            fadeOut.start();
        }
    }

    private void showEmptyView() {
        if (mEmptyView == null)
            return;

        ValueAnimator fadeOut = getObjectAnimator(this, 1, 0).setDuration(ANIMATION_DURATION);
        fadeOut.addListener(getAnimationListener(this, View.GONE));
        fadeOut.start();

        ValueAnimator fadeIn = getObjectAnimator(mEmptyView, 0, 1).setDuration(ANIMATION_DURATION);
        fadeIn.addListener(getAnimationListener(mEmptyView, View.VISIBLE));
        fadeIn.start();
    }

    private ValueAnimator getObjectAnimator(View target, int start, int end) {
        return ObjectAnimator.ofFloat(target, "alpha", start, end);
    }

    private Animator.AnimatorListener getAnimationListener(final View view, final int visibilityOnEnd) {
        return new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animation) {}

            @Override
            public void onAnimationEnd(Animator animation) { view.setVisibility(visibilityOnEnd); }

            @Override
            public void onAnimationRepeat(Animator animation) {}

            @Override
            public void onAnimationCancel(Animator animation) {}
        };
    }
}
