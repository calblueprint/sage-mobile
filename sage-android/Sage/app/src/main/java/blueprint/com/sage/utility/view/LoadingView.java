package blueprint.com.sage.utility.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.LinearLayout;

/**
 * Created by charlesx on 2/20/16.
 */
public class LoadingView extends LinearLayout {

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

    }
}

