package blueprint.com.sage.signUp.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

/**
 * Created by charlesx on 10/14/15.
 * Spinner adapter for volunteer types.
 */
public class SignUpTypeSpinnerAdapter extends ArrayAdapter<String> {
    private String[] mTypes;
    private Context mContext;
    private int mLayoutId;
    private int mTextViewId;

    private TextView mTextView;

    public SignUpTypeSpinnerAdapter(Context context, int layoutId, int textViewId, String[] types) {
        super(context, layoutId, textViewId);
        mTypes = types;
        mContext = context;
        mLayoutId = layoutId;
        mTextViewId = textViewId;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public String getItem(int position) {
        return mTypes[position];
    }

    @Override
    public int getCount() {
        return mTypes.length;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(mLayoutId, parent, false);
        }

        mTextView = (TextView) convertView.findViewById(mTextViewId);
        mTextView.setText(getItem(position));

        return convertView;
    }

}
