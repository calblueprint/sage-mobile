package blueprint.com.sage.shared.views;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.support.v4.content.ContextCompat;
import android.util.AttributeSet;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.MotionEvent;
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
public class SimpleLoadingLayout extends LinearLayout {
    private static final int DEFAULT_SPIN_TIME = 500;
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
        super(context, attrSet);
        initializeView(context, attrSet);
    }

    private void initializeView(Context context, AttributeSet attrSet) {
        setGravity(Gravity.CENTER);

        TypedArray attributes =
                context.getTheme().obtainStyledAttributes(attrSet, R.styleable.SimpleLoadingLayout, 0, 0);

        mTextColor = attributes.getColor(R.styleable.SimpleLoadingLayout_textColor, Color.BLACK);
        mTextSize = attributes.getDimensionPixelSize(R.styleable.SimpleLoadingLayout_android_textSize, TEXT_SIZE_DP);
        mText = attributes.getString(R.styleable.SimpleLoadingLayout_text);

        mIsLoading = false;

        mLoadingImage = ContextCompat.getDrawable(context, R.drawable.spinner);

        attributes.recycle();

        mAnimation = AnimationUtils.loadAnimation(getContext(), R.anim.rotate);

        setButton();
        setImageView();

        addView(mButton);
    }

    private void setButton() {
        mButton = new Button(getContext());
        LinearLayout.LayoutParams params =
                new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT);

        mButton.setText(mText);
        mButton.setTextSize(TypedValue.COMPLEX_UNIT_PX, mTextSize);
        mButton.setTextColor(mTextColor);
        mButton.setAllCaps(false);
        mButton.setClickable(false);

        mButton.setBackgroundColor(ContextCompat.getColor(getContext(), R.color.transparent));
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

    public void startSpinning() {
        mIsLoading = true;

        removeAllViews();
        addView(mImageView);
        mImageView.startAnimation(mAnimation);
        setBackground(ContextCompat.getDrawable(getContext(), R.drawable.translucent_button_unpressed));
        invalidate();
    }

    public void stopSpinning() {
        mIsLoading = false;

        removeAllViews();
        addView(mButton);

        setBackground(ContextCompat.getDrawable(getContext(), R.drawable.translucent_button));
        invalidate();
    }

    public boolean isSpinning() {
        return mIsLoading;
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            if (!isSpinning()) {
                startSpinning();
            }
        }
        return super.onTouchEvent(event);
    }
}
