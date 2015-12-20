package blueprint.com.sage.shared.views;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.drawable.Animatable;
import android.graphics.drawable.Drawable;
import android.text.TextPaint;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageButton;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 12/20/15.
 * A simple button that shows a loading spin after being clicked
 */
public class SimpleLoadingButton extends ImageButton implements View.OnClickListener {

    // Add this as a xml attribute later;
    private static final int TEXT_SIZE_DP = 14;

    private boolean mIsLoading;
    private Drawable mLoadingImage;

    // Text Properties
    private TextPaint mTextPaint;
    private int mTextColor;
    private int mTextSize;
    private String mText;

    public SimpleLoadingButton(Context context) {
        super(context);
    }

    public SimpleLoadingButton(Context context, AttributeSet attrSet) {
        this(context, attrSet, 0);
        initializeView(context, attrSet);
    }

    public SimpleLoadingButton(Context context, AttributeSet attrSet, int defAttrStyle) {
        super(context, attrSet, defAttrStyle);
        initializeView(context, attrSet);
    }

    private void initializeView(Context context, AttributeSet attrSet) {
        TypedArray attributes =
                context.getTheme().obtainStyledAttributes(attrSet, R.styleable.FloatingTextView, 0, 0);
        mTextPaint = new TextPaint();
        mTextColor = attributes.getColor(R.styleable.SimpleLoadingButton_android_textColor, Color.BLACK);
        mTextSize = attributes.getDimensionPixelSize(R.styleable.SimpleLoadingButton_android_textSize, TEXT_SIZE_DP);
        mText = attributes.getString(R.styleable.SimpleLoadingButton_android_text);

        mTextPaint.setColor(mTextColor);
        mTextPaint.setTextSize(mTextSize);

        mLoadingImage =  getDrawable();
        mLoadingImage.setAlpha(0);
    }

    @Override
    public void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        if (isSpinning()) {
            showAnimation(true);
        } else {
            showAnimation(false);
            showText(canvas);
        }
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

    private void showText(Canvas canvas) {
        int xPos = (canvas.getWidth() / 2);
        int yPos = (int) ((canvas.getHeight() / 2) - ((mTextPaint.descent() + mTextPaint.ascent()) / 2)) ;

        canvas.drawText(mText, xPos, yPos, mTextPaint);
    }

    private void showAnimation(boolean shouldSpin) {
        if (!(mLoadingImage instanceof Animatable)) return;

        Animatable loader = (Animatable) mLoadingImage;

        if (shouldSpin) {
            mLoadingImage.setAlpha(255);
            loader.start();
        } else {
            mLoadingImage.setVisible(false, false);
            mLoadingImage.setAlpha(0);
            loader.stop();
        }
    }

    @Override
    public void onClick(View view) {
        if (isSpinning()) return;
        startSpinning();
    }
}
