package blueprint.com.sage.sign_up.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;

import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/14/15.
 * Spinner adapter for volunteer types.
 */
public class SignUpTypeSpinnerAdapter extends ArrayAdapter<String> {
    private String[] mTypes;
    private Context mContext;
    private int mLayoutId;

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
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(mLayoutId, parent, false);
        }

        ButterKnife.bind(mContext, convertView);

        return convertView;
    }

}
