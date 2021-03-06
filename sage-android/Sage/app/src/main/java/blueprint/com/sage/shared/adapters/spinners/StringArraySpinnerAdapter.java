package blueprint.com.sage.shared.adapters.spinners;

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
public class StringArraySpinnerAdapter extends ArrayAdapter<String> {
    private String[] mArray;
    private Context mContext;

    private int mSpinnerItem;
    private int mSpinnerDropdown;

    public StringArraySpinnerAdapter(Context context, String[] array, int spinnerItem, int spinnerDropdown) {
        super(context, spinnerItem);
        mArray = array;
        mContext = context;
        mSpinnerItem = spinnerItem;
        mSpinnerDropdown = spinnerDropdown;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public String getItem(int position) {
        return mArray[position];
    }

    @Override
    public int getCount() {
        return mArray.length;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        return getCustomView(position, convertView, parent, mSpinnerItem);
    }

    @Override
    public View getDropDownView(int position, View convertView, ViewGroup parent) {
        return getCustomView(position, convertView, parent, mSpinnerDropdown);
    }

    private View getCustomView(int position, View convertView, ViewGroup parent, int layoutId) {
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(layoutId, parent, false);
        }

        TextView textView = (TextView) convertView.findViewById(R.id.spinner_item_text);
        textView.setText(getItem(position));

        return convertView;
    }
}
