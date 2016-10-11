package blueprint.com.sage.shared.views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.ImageView;
import android.widget.LinearLayout;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 1/4/16.
 */
public class ImageTabView extends LinearLayout {

    private ImageView mImageView;

    public ImageTabView(Context context) {
        super(context);
        initializeViews();
    }

    public ImageTabView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initializeViews();
    }

    public ImageTabView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        initializeViews();
    }

    private void initializeViews() {
        LayoutInflater inflater = (LayoutInflater) getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        inflater.inflate(R.layout.tab_view, this, true);

        mImageView = (ImageView) findViewById(R.id.tab_view_image);
    }

    public void setImage(int drawableId) {
        mImageView.setImageResource(drawableId);
        invalidate();
    }

    public void setImageAlpha(float alpha) {
        mImageView.setAlpha(alpha);
    }
}
