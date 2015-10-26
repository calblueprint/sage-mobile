package blueprint.com.sage.signUp.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import blueprint.com.sage.R;

/**
 * Created by charlesx on 10/14/15.
 * Spinner adapter for volunteer types.
 */
public class SignUpTypeSpinnerAdapter extends ArrayAdapter<String> {
    private String[] mTypes;
    private Context mContext;
    private int mLayoutId;

    private TextView mTextView;

    public SignUpTypeSpinnerAdapter(Context context, int layoutId, String[] types) {
        super(context, layoutId);
        mTypes = types;
        mContext = context;
        mLayoutId = layoutId;
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
        return getCustomView(position, convertView, parent, R.layout.sign_in_spinner_item);
    }

    @Override
    public View getDropDownView(int position, View convertView, ViewGroup parent) {
        return getCustomView(position, convertView, parent, R.layout.sign_in_spinner_drop_item);
    }

    private View getCustomView(int position, View convertView, ViewGroup parent, int layoutId) {
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(layoutId, parent, false);
        }

        mTextView = (TextView) convertView.findViewById(R.id.sign_up_spinner_item_text);
        mTextView.setText(getItem(position));

        return convertView;
    }

}
