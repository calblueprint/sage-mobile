package blueprint.com.sage.sign_up.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;

import java.util.List;

import blueprint.com.sage.models.School;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/14/15.
 * Adapter for the sign up spinner
 */
public class SignUpSchoolSpinnerAdapter extends ArrayAdapter<School> {
    private List<School> mSchools;
    private Context mContext;
    private int mLayoutId;

    public SignUpSchoolSpinnerAdapter(Context context, int layoutId, List<School> schools) {
        super(context, layoutId);
        mSchools = schools;
        mContext = context;
        mLayoutId = layoutId;
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

        ButterKnife.bind(mContext, convertView);

        return convertView;
    }

}
