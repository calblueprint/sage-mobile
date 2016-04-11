package blueprint.com.sage.shared.views;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.MotionEvent;

import com.google.android.gms.maps.GoogleMapOptions;
import com.google.android.gms.maps.MapView;

import blueprint.com.sage.R;
import blueprint.com.sage.utility.view.MapUtils;
import blueprint.com.sage.utility.view.ViewUtils;

/**
 * Created by kelseylam on 2/24/16.
 */
public class ScrollMapView extends MapView {

    private int mRadius;

    public ScrollMapView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public ScrollMapView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    public ScrollMapView(Context context, GoogleMapOptions options) {
        super(context, options);
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        int action = ev.getAction();
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                this.getParent().getParent().getParent().requestDisallowInterceptTouchEvent(true);
                break;

            case MotionEvent.ACTION_UP:
                this.getParent().getParent().getParent().requestDisallowInterceptTouchEvent(true);
                break;
        }

        // Handle MapView's touch events.
        super.dispatchTouchEvent(ev);
        return true;
    }

    @Override
    public void dispatchDraw(Canvas canvas) {
        super.dispatchDraw(canvas);

        Paint paintFill = new Paint();
        paintFill.setColor(ViewUtils.getColor(getContext(), R.color.map_circle_fill));
        paintFill.setStyle(Paint.Style.FILL);

        int widthMiddle = getMeasuredWidth();
        int heightMiddle = getMeasuredHeight();

        canvas.drawCircle(widthMiddle / 2, heightMiddle / 2, mRadius, paintFill);
    }

    public void setRadius(int radius) {
        mRadius = MapUtils.convertRadius(this, getMap(), radius);
        invalidate();
    }
}
