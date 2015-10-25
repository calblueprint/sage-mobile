package blueprint.com.sage.signUp.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import butterknife.Bind;

/**
 * Created by charlesx on 10/14/15.
 * Adapter for the sign up spinner
 */
public class SignUpSchoolSpinnerAdapter extends ArrayAdapter<School> {
    private List<School> mSchools;
    private Context mContext;
    private int mLayoutId;
    private int mTextViewId;

    @Bind(R.id.sign_up_spinner_item_text) TextView mTextView;

    public SignUpSchoolSpinnerAdapter(Context context, int layoutId, int textViewId, List<School> schools) {
        super(context, layoutId, textViewId);
        mSchools = schools;
        mContext = context;
        mLayoutId = layoutId;
        mTextViewId = textViewId;
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
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(mLayoutId, parent, false);
        }

        mTextView = (TextView) convertView.findViewById(R.id.sign_up_spinner_item_text);
        mTextView.setText(getItem(position).getName());

        return convertView;
    }

}
