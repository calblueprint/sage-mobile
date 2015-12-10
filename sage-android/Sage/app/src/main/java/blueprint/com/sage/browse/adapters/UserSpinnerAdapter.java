package blueprint.com.sage.browse.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;

/**
 * Created by charlesx on 11/29/15.
 */
public class UserSpinnerAdapter extends ArrayAdapter<User> {

    private List<User> mUsers;
    private Context mContext;
    private int mSpinnerItem;
    private int mSpinnerDropdown;

    private TextView mTextView;

    public UserSpinnerAdapter(Context context, List<User> users,
                                int spinnerItem, int spinnerDropdown) {
        super(context, spinnerItem);
        mUsers = users;
        mContext = context;
        mSpinnerItem = spinnerItem;
        mSpinnerDropdown = spinnerDropdown;
    }

    @Override
    public long getItemId(int position) {
        return mUsers.get(position).getId();
    }

    @Override
    public User getItem(int position) {
        return mUsers.get(position);
    }

    @Override
    public int getCount() {
        return mUsers.size();
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

    public void setUsers(List<User> users) {
        mUsers = users;
        notifyDataSetChanged();
    }
}
