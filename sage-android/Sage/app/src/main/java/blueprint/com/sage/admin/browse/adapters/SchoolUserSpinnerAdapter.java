package blueprint.com.sage.admin.browse.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import lombok.Data;

/**
 * Created by charlesx on 2/10/16.
 */
public class SchoolUserSpinnerAdapter extends ArrayAdapter<SchoolUserSpinnerAdapter.Item> {

    private Context mContext;
    private int mDropDownHeaderId;
    private int mDropDownListId;
    private List<Item> mItems;

    public SchoolUserSpinnerAdapter(Context context, List<User> users, int dropDownHeaderId, int dropDownListId) {
        super(context, dropDownHeaderId);
        mContext = context;
        mDropDownHeaderId = dropDownHeaderId;
        mDropDownListId = dropDownListId;

        setUpUsers(users);
    }

    private void setUpUsers(List<User> users) {
        mItems = new ArrayList<>();
        mItems.add(new Item(null, "Select Director"));

        for (User user : users) {
            mItems.add(new Item(user, null));
        }
    }

    @Override
    public Item getItem(int position) { return mItems.get(position); }

    @Override
    public int getCount() {
        return mItems.size();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        return getCustomView(position, convertView, parent, mDropDownHeaderId);
    }

    @Override
    public View getDropDownView(int position, View convertView, ViewGroup parent) {
        return getCustomView(position, convertView, parent, mDropDownListId);
    }

    private View getCustomView(int position, View convertView, ViewGroup parent, int layoutId) {
        if (convertView == null) {
            LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            convertView = inflater.inflate(layoutId, parent, false);
        }

        TextView textView = (TextView) convertView.findViewById(R.id.spinner_item_text);
        textView.setText(mItems.get(position).toString());

        return convertView;
    }

    public void setUsers(List<User> users) {
        setUpUsers(users);
        notifyDataSetChanged();
    }

    @Data
    public static class Item {
        private User user;
        private String header;

        public Item(User user, String header) {
            this.user = user;
            this.header = header;
        }

        public int toInt() {
            return user == null ? 0 : user.getId();
        }

        @Override
        public String toString() {
            return user == null ? header : user.getName();
        }
    }
}
