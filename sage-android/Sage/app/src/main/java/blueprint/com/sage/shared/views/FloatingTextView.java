package blueprint.com.sage.shared.views;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.support.design.widget.FloatingActionButton;
import android.util.AttributeSet;

import blueprint.com.sage.R;
import blueprint.com.sage.utility.view.ViewUtils;

/**
 * Created by charlesx on 11/3/15.
 * Floating action button with text
 */
public class FloatingTextView extends FloatingActionButton {

    // Add this as a xml attribute later;
    private static final int TEXT_SIZE_DP = 14;

    private Paint mTextPaint;
    private String mText;
    private int mTextColor;
    private int mTextSize;

    public FloatingTextView(Context context) { super(context); }

    public FloatingTextView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public FloatingTextView(Context context, AttributeSet attrs, int defAttrStyle) {
        super(context, attrs, defAttrStyle);
        initializeAttrs(context, attrs);
    }

    private void initializeAttrs(Context context, AttributeSet attrs) {
        mTextPaint = new Paint();

        TypedArray attributes =
                context.getTheme().obtainStyledAttributes(attrs, R.styleable.FloatingTextView, 0, 0);

        mTextColor = attributes.getColor(R.styleable.FloatingTextView_android_textColor, Color.BLACK);
        String text = attributes.getString(R.styleable.FloatingTextView_android_text);
        if (text != null)
            mText = text;
        mTextSize = attributes.getDimensionPixelSize(R.styleable.FloatingTextView_android_textSize, TEXT_SIZE_DP);

        attributes.recycle();
    }

    @Override
    public void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        if (mText == null)
            return;

        mTextPaint.setTextAlign(Paint.Align.CENTER);
        mTextPaint.setColor(mTextColor);
        mTextPaint.setAntiAlias(true);

        mTextPaint.setTextSize(mTextSize);

        int xPos = (canvas.getWidth() / 2);
        int yPos = (int) ((canvas.getHeight() / 2) - ((mTextPaint.descent() + mTextPaint.ascent()) / 2)) ;

        canvas.drawText(mText, xPos, yPos, mTextPaint);
    }

    public void setText(String text) {
        mText = text;
        invalidate();
    }
}
