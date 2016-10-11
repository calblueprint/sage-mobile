package blueprint.com.sage.shared.views;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Shader;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.ThumbnailUtils;
import android.os.Build;
import android.util.AttributeSet;
import android.util.Log;
import android.widget.ImageView;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 10/13/15.
 * Credits to mikhaellopez for original source
 */
public class CircleImageView extends ImageView {
    private Paint mPaint;
    private Paint mBorder;

    private int mBorderWidth;
    private int mCanvasSize;

    private Drawable mDrawable;
    private Bitmap mImage;

    public CircleImageView(Context context) {
        super(context, null);
    }

    public CircleImageView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public CircleImageView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context, attrs, defStyleAttr);
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public CircleImageView(Context context, AttributeSet attrs, int defStyleAttr, int defStyleRes) {
        super(context, attrs, defStyleAttr, defStyleRes);
        init(context, attrs, defStyleAttr);
    }

    private void init(Context context, AttributeSet attrs, int defStyleAttr) {
        mPaint = new Paint();
        mPaint.setAntiAlias(true);

        mBorder = new Paint();
        mBorder.setAntiAlias(true);

        TypedArray attributes =
                context.obtainStyledAttributes(attrs, R.styleable.CircleImageView, defStyleAttr, 0);

        if (attributes.getBoolean(R.styleable.CircleImageView_border, true)) {
            int defaultBorderSize = (int) (4 * getContext().getResources().getDisplayMetrics().density + 0.5f);
            setBorderWidth(attributes.getDimensionPixelOffset(R.styleable.CircleImageView_border_width, defaultBorderSize));
            setBorderColor(attributes.getColor(R.styleable.CircleImageView_border_color, Color.WHITE));
        }

//        mPaint.setColor(attributes.getColor(R.styleable.CircleImageView_background_color, Color.TRANSPARENT));

        attributes.recycle();
    }

    public void setBorderWidth(int borderWidth) {
        mBorderWidth = borderWidth;
        requestLayout();
        invalidate();
    }

    public void setBorderColor(int color) {
        if (mBorder != null) mBorder.setColor(color);
        invalidate();
    }

    @Override
    public void onDraw(Canvas canvas) {
        loadBitmap();
        if (mImage == null) return;

        mCanvasSize = Math.min(canvas.getWidth(), canvas.getHeight());

        int circleCenter = (mCanvasSize - (mBorderWidth * 2)) / 2;
        canvas.drawCircle(circleCenter + mBorderWidth, circleCenter + mBorderWidth, circleCenter + mBorderWidth - 4.0f, mBorder);
        canvas.drawCircle(circleCenter + mBorderWidth, circleCenter + mBorderWidth, circleCenter - 4.0f, mPaint);
    }

    private void loadBitmap() {
        if (mDrawable == getDrawable()) return;

        mDrawable = getDrawable();
        mImage = drawableToBitmap(mDrawable);
        updateShader();
    }

    private void updateShader() {
        if (mImage == null) return;
        BitmapShader shader = new BitmapShader(Bitmap.createScaledBitmap(
                ThumbnailUtils.extractThumbnail(mImage, mCanvasSize,
                        mCanvasSize), mCanvasSize, mCanvasSize, false),
                Shader.TileMode.CLAMP, Shader.TileMode.CLAMP);

        mPaint.setShader(shader);
    }

    private Bitmap drawableToBitmap(Drawable drawable) {
        if (drawable == null) {
            return null;
        } else if (drawable instanceof BitmapDrawable) {
            return ((BitmapDrawable) drawable).getBitmap();
        }

        int width = drawable.getIntrinsicWidth();
        int height = drawable.getIntrinsicHeight();

        if (!(width > 0 && height > 0)) return null;

        try {
            Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            Canvas canvas = new Canvas(bitmap);
            drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
            drawable.draw(canvas);
            return bitmap;
        } catch (OutOfMemoryError e) {
            // Simply return null of failed bitmap creations
            Log.e(getClass().toString(), "Encountered OutOfMemoryError while generating bitmap!");
            return null;
        }
    }

    @Override
    protected  void onSizeChanged(int w, int h, int oldw, int oldh) {
        super.onSizeChanged(w, h, oldw, oldh);
        mCanvasSize = Math.min(w, h);

        if (mImage != null) {
            updateShader();
        }
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int width = measureWidth(widthMeasureSpec);
        int height = measureHeight(heightMeasureSpec);

        setMeasuredDimension(width, height);
    }

    private int measureWidth(int widthMeasureSpec) {
        int result;
        int specMode = MeasureSpec.getMode(widthMeasureSpec);
        int specSize = MeasureSpec.getSize(widthMeasureSpec);

        if (specMode == MeasureSpec.EXACTLY || specMode == MeasureSpec.AT_MOST) {
            result = specSize;
        } else {
            result = mCanvasSize;
        }

        return result;
    }

    private int measureHeight(int heightMeasureSpec) {
        int result;
        int specMode = MeasureSpec.getMode(heightMeasureSpec);
        int specSize = MeasureSpec.getSize(heightMeasureSpec);

        if (specMode == MeasureSpec.EXACTLY || specMode == MeasureSpec.AT_MOST) {
            result = specSize;
        } else {
            result = mCanvasSize;
        }

        return result + 2;
    }

    public Bitmap getImageBitmap() { return mImage; }
}
