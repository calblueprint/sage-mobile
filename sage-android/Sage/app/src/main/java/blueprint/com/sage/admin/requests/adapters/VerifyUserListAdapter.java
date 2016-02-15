package blueprint.com.sage.admin.requests.adapters;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.views.CircleImageView;
import butterknife.Bind;
import butterknife.ButterKnife;
import lombok.Data;

/**
 * Created by charlesx on 11/14/15.
 */
public class VerifyUserListAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private Activity mActivity;
    private List<Item> mItems;

    private final static String NO_SCHOOL = "No School";

    public VerifyUserListAdapter(Activity activity, List<User> users) {
        super();
        mActivity = activity;
        setUpUsers(users);
    }

    // TODO: Sets up similar schools together - will fix this later
    private void setUpUsers(List<User> users) {
        mItems = new ArrayList<>();

        HashMap<String, List<Item>> userMap = new HashMap<>();

        for (User user : users) {
            if (user.getSchool() == null) {
                if (userMap.containsKey(NO_SCHOOL))
                    userMap.put(NO_SCHOOL, new ArrayList<Item>());
                userMap.get(NO_SCHOOL).add(new Item(user, null, false));
                continue;
            }

            if (userMap.containsKey(user.getSchool().getName())) {
                userMap.put(user.getSchool().getName(), new ArrayList<Item>());
            }
            userMap.get(user.getSchool().getName()).add(new Item(user, null, false));
        }

        for (String key : userMap.keySet()) {
            mItems.add(new Item(null, key, true));

            for (Item item : userMap.get(key))
                mItems.add(item);
        }
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int position) {
        Item item = mItems.get(position);
        if (item.isHeader()) {
            View view = LayoutInflater.from(mActivity).inflate(R.layout.user_header_list_item, parent, false);
            return new HeaderViewHolder(view);
        } else {
            View view = LayoutInflater.from(mActivity).inflate(R.layout.verify_users_list_item, parent, false);
            return new UserViewHolder(view);
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, final int position) {
        if (getItemCount() == 0 || position < 0 || position >= getItemCount())
            return;

        Item item = mItems.get(position);

        if (item.isHeader()) {
            bindHeaderHolder((HeaderViewHolder) viewHolder, item);
        } else {
            bindUserHolder((UserViewHolder) viewHolder, item);
        }
    }

    private void bindHeaderHolder(HeaderViewHolder viewHolder, Item item) {
        viewHolder.mHeader.setText(item.getHeader());
    }

    private void bindUserHolder(UserViewHolder viewHolder, final Item item) {
        final User user = item.getUser();
        viewHolder.mName.setText(user.getName());

        if (user.getSchool() != null) {
            viewHolder.mSchool.setText(user.getSchool().getName());
        }

        viewHolder.mVerify.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                int position = mItems.indexOf(item);
                Requests.Users.with(mActivity).makeVerifyRequest(user, position);
            }
        });

        viewHolder.mDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                int position = mItems.indexOf(item);
                Requests.Users.with(mActivity).makeDeleteRequest(user, position);
            }
        });

        user.loadUserImage(mActivity, viewHolder.mImage);
    }

    @Override
    public int getItemCount() { return mItems.size(); }

    public void setUsers(List<User> users) {
        setUpUsers(users);
        notifyDataSetChanged();
    }

    public void removeUser(int position) {
        mItems.remove(position);
        notifyItemRemoved(position);
    }

    public static class HeaderViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.user_header_list_name) TextView mHeader;

        public HeaderViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
        }
    }

    public static class UserViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.verify_user_list_photo) CircleImageView mImage;
        @Bind(R.id.verify_user_list_name) TextView mName;
        @Bind(R.id.verify_user_list_school) TextView mSchool;
        @Bind(R.id.verify_user_list_item_verify) ImageButton mVerify;
        @Bind(R.id.verify_user_list_item_delete) ImageButton mDelete;

        public UserViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
        }
    }

    @Data
    public static class Item {
        private User user;
        private String header;
        private boolean isHeader;

        public Item(User user, String header, boolean isHeader) {
            this.user = user;
            this.header = header;
            this.isHeader = isHeader;
        }
    }
}
