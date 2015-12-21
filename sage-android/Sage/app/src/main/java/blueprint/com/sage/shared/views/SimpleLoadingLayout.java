package blueprint.com.sage.shared.views;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;

import blueprint.com.sage.R;
import blueprint.com.sage.utility.view.ViewUtils;

/**
 * Created by charlesx on 12/20/15.
 * A simple button that shows a loading spin after being clicked
 */
public class SimpleLoadingLayout extends LinearLayout implements View.OnClickListener {
    private static final int DEFAULT_SPIN_TIME = 1000;
    // Add this as a xml attribute later;
    private static final int TEXT_SIZE_DP = 14;

    // Text Attributes
    private int mTextColor;
    private int mTextSize;
    private String mText;

    private boolean mIsLoading;
    private Drawable mLoadingImage;

    private Button mButton;
    private ImageView mImageView;

    private Animation mAnimation;

    public SimpleLoadingLayout(Context context) {
        super(context);
    }

    public SimpleLoadingLayout(Context context, AttributeSet attrSet) {
        this(context, attrSet, 0);
        initializeView(context, attrSet);
    }

    public SimpleLoadingLayout(Context context, AttributeSet attrSet, int defAttrStyle) {
        super(context, attrSet, defAttrStyle);
        initializeView(context, attrSet);
    }

    private void initializeView(Context context, AttributeSet attrSet) {
        setGravity(Gravity.CENTER);

        TypedArray attributes =
                context.getTheme().obtainStyledAttributes(attrSet, R.styleable.FloatingTextView, 0, 0);

        mTextColor = attributes.getColor(R.styleable.SimpleLoadingLayout_android_textColor, Color.BLACK);
        mTextSize = attributes.getDimensionPixelSize(R.styleable.SimpleLoadingLayout_android_textSize, TEXT_SIZE_DP);
        mText = attributes.getString(R.styleable.SimpleLoadingLayout_android_text);

        mIsLoading = false;
        mLoadingImage = context.getResources().getDrawable(R.drawable.spin, context.getTheme());

        attributes.recycle();

        mAnimation = AnimationUtils.loadAnimation(getContext(), R.anim.rotate);
        mAnimation.setDuration(1000);

        setButton();
        setImageView();

        addView(mButton);
        addView(mImageView);
    }

    private void setButton() {
        mButton = new Button(getContext());
        LinearLayout.LayoutParams params =
                new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT);

        mButton.setText(mText);
        mButton.setTextSize(mTextSize);
        mButton.setTextColor(mTextColor);
        mButton.setAllCaps(false);
        mButton.setBackgroundColor(getResources().getColor(R.color.transparent, getContext().getTheme()));
        mButton.setLayoutParams(params);
    }

    private void setImageView() {
        mImageView = new ImageView(getContext());

        int size = ViewUtils.convertFromDpToPx(getContext(), 25);
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(size, size);

        mImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        mImageView.setImageDrawable(mLoadingImage);
        mImageView.setLayoutParams(params);
    }

    @Override
    public void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        if (isSpinning()) {
            toggleView(true, mImageView);
            toggleView(false, mButton);
            showAnimation(true);
        } else {
            toggleView(false, mImageView);
            toggleView(true, mButton);
            showAnimation(false);
        }
    }

    private void toggleView(boolean shouldShow, View view) {
        int visibility = shouldShow ? View.VISIBLE : View.GONE;
        view.setVisibility(visibility);
    }

    public void startSpinning() {
        mIsLoading = true;
        invalidate();
    }

    public void stopSpinning() {
        mIsLoading = false;
        invalidate();
    }

    public boolean isSpinning() {
        return mIsLoading;
    }

    private void showAnimation(boolean shouldSpin) {
        if (shouldSpin) {
            mImageView.startAnimation(mAnimation);
        } else {
            mImageView.clearAnimation();
        }
    }

    @Override
    public void onClick(View view) {
        if (isSpinning()) return;
        startSpinning();
    }
}
