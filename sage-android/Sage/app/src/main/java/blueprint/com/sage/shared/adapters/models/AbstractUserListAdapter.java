package blueprint.com.sage.shared.adapters.models;

import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.support.v4.app.FragmentActivity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.views.CircleImageView;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/17/15.
 */
public abstract class AbstractUserListAdapter extends RecyclerView.Adapter<RecyclerView.ViewHolder> {

    public FragmentActivity mActivity;
    public List<Item> mItemList;

    private static final int HEADER_VIEW = 0;
    private static final int USER_VIEW = 1;
    public final static String[] ROLES = { "!", "A", "P", "D" };


    public AbstractUserListAdapter(FragmentActivity activity, List<User> users) {
        super();
        mActivity = activity;
    }

    public abstract void setUpUsers(List<User> users);

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

        if (user.getSchool() != null) {
            viewHolder.mSchool.setText(user.getSchool().getName());
        }

        viewHolder.mView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onItemClick(user);
            }
        });
        user.loadUserImage(mActivity, viewHolder.mImage);

        int role = user.getRole();
        if (user.getDirectorId() != 0) {
            role = 3;
        }
        viewHolder.mUserType.setVisibility(View.VISIBLE);
        viewHolder.mBorder.setVisibility(View.VISIBLE);
        viewHolder.mUserType.setTypeface(null, Typeface.BOLD);
        GradientDrawable shape = (GradientDrawable) viewHolder.mUserType.getBackground();
        viewHolder.mUserType.setText(ROLES[role]);
        switch(role) {
            case 0:
                if (user.getUserSemester() != null && !user.getUserSemester().isActive()) {
                    shape.setColor(mActivity.getResources().getColor(R.color.red_endangered));
                } else {
                    viewHolder.mBorder.setVisibility(View.GONE);
                    viewHolder.mUserType.setVisibility(View.GONE);
                }
                break;
            case 1:
                shape.setColor(mActivity.getResources().getColor(R.color.orange_admin));
                break;
            case 2:
                shape.setColor(mActivity.getResources().getColor(R.color.blue_president));
                break;
            case 3:
                shape.setColor(mActivity.getResources().getColor(R.color.turquoise_director));
                break;
        }
    }

    public abstract void onItemClick(User user);

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
        @Bind(R.id.user_type_circle) TextView mUserType;
        @Bind(R.id.user_type_circle_border) ImageView mBorder;

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
