package blueprint.com.sage.shared.views;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.support.design.widget.FloatingActionButton;
import android.util.AttributeSet;

import blueprint.com.sage.utility.view.ViewUtils;

/**
 * Created by charlesx on 11/3/15.
 */
public class FloatingTextView extends FloatingActionButton {

    // Add this as a xml attribute later;
    private static final int TEXT_SIZE_DP = 14;

    private Paint mTextPaint;
    private String mText;

    public FloatingTextView(Context context) {
        super(context);
        initializeView();
    }

    public FloatingTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initializeView();
    }

    public FloatingTextView(Context context, AttributeSet attrs, int defAttrStyle) {
        super(context, attrs, defAttrStyle);
        initializeView();
    }

    private void initializeView() {
        mTextPaint = new Paint();
        mText = "00:00:00";
    }

    @Override
    public void onDraw(Canvas canvas) {
        super.onDraw(canvas);

        mTextPaint.setTextAlign(Paint.Align.CENTER);
        mTextPaint.setColor(Color.BLACK);
        mTextPaint.setAntiAlias(true);

        float textSize = ViewUtils.convertFromDpToPx(getContext(), TEXT_SIZE_DP);
        mTextPaint.setTextSize(textSize);
        float x = getX();
        float y = getY();

        int xPos = (canvas.getWidth() / 2);
        int yPos = (int) ((canvas.getHeight() / 2) - ((mTextPaint.descent() + mTextPaint.ascent()) / 2)) ;

        canvas.drawText(mText, xPos, yPos, mTextPaint);
    }
}
