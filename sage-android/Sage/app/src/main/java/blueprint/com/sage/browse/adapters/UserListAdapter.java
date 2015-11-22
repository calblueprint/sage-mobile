package blueprint.com.sage.browse.adapters;

import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.fragments.UserFragment;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/17/15.
 */
public class UserListAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    private FragmentActivity mActivity;
    private List<Item> mItemList;

    private static final int HEADER_VIEW = 0;
    private static final int USER_VIEW = 1;

    public UserListAdapter(FragmentActivity activity, List<User> users) {
        super();
        mActivity = activity;
        setUpUsers(users);
    }

    private void setUpUsers(List<User> users) {
        List<Item> allUsers = new ArrayList<>();
        List<Item> inactiveUsers = new ArrayList<>();

        for (User user : users) {
            Item item = new Item(user, null, false);
            allUsers.add(item);

            if (!user.isActive())
                inactiveUsers.add(item);
        }

        mItemList = new ArrayList<>();

        if (inactiveUsers.size() != 0) {
            mItemList.add(new Item(null, "Inactive Users", true));
            mItemList.addAll(inactiveUsers);
        }

        if (allUsers.size() != 0) {
            mItemList.add(new Item(null, "All Users", true));
            mItemList.addAll(allUsers);
        }
    }

    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(ViewGroup parent, int type) {
        View view;
        switch (type) {
            case HEADER_VIEW:
                view = LayoutInflater.from(mActivity).inflate(R.layout.user_header_list_item, parent, false);
                return new HeaderViewHolder(view);
            default:
                view = LayoutInflater.from(mActivity).inflate(R.layout.user_list_item, parent, false);
                return new UserViewHolder(view);
        }
    }

    @Override
    public void onBindViewHolder(RecyclerView.ViewHolder viewHolder, int position) {
        if (getItemCount() == 0 || position >= getItemCount() || position < 0)
            return;

        Item item = mItemList.get(position);

        if (item.isHeader()) {
            setUpHeaderView((HeaderViewHolder) viewHolder, item);
        } else {
            setUpUserView((UserViewHolder) viewHolder, item);
        }
    }

    private void setUpHeaderView(HeaderViewHolder viewHolder, Item item) {
        viewHolder.mHeader.setText(item.getHeader());
    }

    private void setUpUserView(UserViewHolder viewHolder, Item item) {
        final User user = item.getUser();
        viewHolder.mName.setText(user.getName());
        viewHolder.mSchool.setText(user.getSchool().getName());
        viewHolder.mHours.setText(user.getHoursString());
        viewHolder.mView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                FragUtils.replaceBackStack(R.id.container, UserFragment.newInstance(user), mActivity);
            }
        });
        user.loadUserImage(mActivity, viewHolder.mImage);
    }

    public void setUsers(List<User> users) {
        setUpUsers(users);
        notifyDataSetChanged();
    }

    @Override
    public int getItemCount() { return mItemList.size(); }

    @Override
    public int getItemViewType(int position) {
        return mItemList.get(position).isHeader() ? HEADER_VIEW : USER_VIEW;
    }

    public static class HeaderViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.user_header_list_name) TextView mHeader;

        public HeaderViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
        }

    }

    public static class UserViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.user_list_name) TextView mName;
        @Bind(R.id.user_list_school) TextView mSchool;
        @Bind(R.id.user_list_photo) CircleImageView mImage;
        @Bind(R.id.user_list_hours) TextView mHours;

        View mView;

        public UserViewHolder(View v) {
            super(v);
            mView = v;
            ButterKnife.bind(this, v);
        }

    }

    public static class Item {

        private User mUser;
        private String mHeader;
        private boolean mIsHeader;

        public Item(User user, String header, boolean isHeader) {
            mUser = user;
            mHeader = header;
            mIsHeader = isHeader;
        }

        public User getUser() { return mUser; }
        public String getHeader() { return mHeader; }
        public boolean isHeader() { return mIsHeader; }
    }
}
