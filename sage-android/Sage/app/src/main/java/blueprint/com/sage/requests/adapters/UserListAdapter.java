package blueprint.com.sage.requests.adapters;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.views.CircleImageView;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/14/15.
 */
public class UserListAdapter extends RecyclerView.Adapter<UserListAdapter.ViewHolder>{

    private Activity mActivity;
    private int mLayoutId;
    private List<User> mUsers;

    public UserListAdapter(Activity activity, int layoutId, List<User> users) {
        super();
        mActivity = activity;
        mLayoutId = layoutId;
        mUsers = users;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int position) {
        View view = LayoutInflater.from(mActivity).inflate(mLayoutId, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int position) {
        if (getItemCount() == 0 || position < 0 || position >= getItemCount())
            return;

    }

    @Override
    public int getItemCount() { return mUsers.size(); }

    public void setUsers(List<User> users) {
        mUsers = users;
        notifyDataSetChanged();
    }

    public void removeUser(int position) {
        mUsers.remove(position);
        notifyItemRemoved(position);
    }

    public static class ViewHolder extends RecyclerView.ViewHolder {

        @Bind(R.id.user_list_photo) CircleImageView mImage;
        @Bind(R.id.user_list_name) TextView mName;
        @Bind(R.id.user_list_school) TextView mSchool;
        @Bind(R.id.user_list_hours) TextView mHours;

        public ViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
        }
    }
}
