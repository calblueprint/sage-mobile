package blueprint.com.sage.shared.views;

import android.content.Context;
import android.util.AttributeSet;
import android.view.View;

/**
 * Created by charlesx on 10/13/15.
 * Adds spacing -- is this hacky?
 */
public class Spacer extends View {

    public Spacer(Context context) {
        this(context, null);
    }

    public Spacer(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public Spacer(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }
}
