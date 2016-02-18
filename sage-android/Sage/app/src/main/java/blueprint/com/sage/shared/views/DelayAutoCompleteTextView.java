package blueprint.com.sage.shared.views;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.util.AttributeSet;
import android.widget.AutoCompleteTextView;

/**
 * Created by kelseylam on 2/17/16.
 */
public class DelayAutoCompleteTextView extends AutoCompleteTextView {
    public DelayAutoCompleteTextView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    private final Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            DelayAutoCompleteTextView.super.performFiltering((CharSequence) msg.obj, msg.arg1);
        }
    };

    @Override
    protected void performFiltering(CharSequence text, int keyCode) {
        mHandler.removeMessages(0);
        mHandler.sendMessageDelayed(mHandler.obtainMessage(0, keyCode, 0, text), 750);
    }
}
