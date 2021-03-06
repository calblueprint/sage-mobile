package blueprint.com.sage.shared.adapters.spinners;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;

/**
 * Created by charlesx on 10/14/15.
 * Adapter for the sign up spinner
 */
public class SchoolSpinnerAdapter extends ArrayAdapter<School> {
    private List<School> mSchools;
    private Context mContext;
    private int mSpinnerItem;
    private int mSpinnerDropdown;

    private TextView mTextView;

    public SchoolSpinnerAdapter(Context context, List<School> schools,
                                int spinnerItem, int spinnerDropdown) {
        super(context, spinnerItem);
        mSchools = schools;
        mContext = context;
        mSpinnerItem = spinnerItem;
        mSpinnerDropdown = spinnerDropdown;
    }

    @Override
    public long getItemId(int position) {
        return mSchools.get(position).getId();
    }

    @Override
    public School getItem(int position) {
        return mSchools.get(position);
    }

    @Override
    public int getCount() {
        return mSchools.size();
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

        mTextView = (TextView) convertView.findViewById(R.id.spinner_item_text);
        mTextView.setText(getItem(position).getName());

        return convertView;
    }

    public void setSchools(List<School> schools) {
        mSchools = schools;
        notifyDataSetChanged();
    }
}
