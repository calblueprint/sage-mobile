package blueprint.com.sage.requests.adapters;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.TextView;

import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.views.CircleImageView;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/14/15.
 */
public class VerifyUserListAdapter extends RecyclerView.Adapter<VerifyUserListAdapter.ViewHolder> {

    private Activity mActivity;
    private int mLayoutId;
    private List<User> mUsers;

    public VerifyUserListAdapter(Activity activity, int layoutId, List<User> users) {
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
    public void onBindViewHolder(ViewHolder viewHolder, final int position) {
        if (getItemCount() == 0 || position < 0 || position >= getItemCount())
            return;

        final User user = mUsers.get(position);

        viewHolder.mName.setText(user.getName());
        viewHolder.mSchool.setText(user.getSchool().getName());

        viewHolder.mVerify.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                int position = mUsers.indexOf(user);
                Requests.Users.with(mActivity).makeVerifyRequest(user, position);
            }
        });

        viewHolder.mDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                int position = mUsers.indexOf(user);
                Requests.Users.with(mActivity).makeDeleteRequest(user, position);
            }
        });

        user.loadUserImage(mActivity, viewHolder.mImage);
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

        @Bind(R.id.verify_user_list_photo) CircleImageView mImage;
        @Bind(R.id.verify_user_list_name) TextView mName;
        @Bind(R.id.verify_user_list_school) TextView mSchool;
        @Bind(R.id.verify_user_list_item_verify) ImageButton mVerify;
        @Bind(R.id.verify_user_list_item_delete) ImageButton mDelete;

        public ViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
        }
    }
}
