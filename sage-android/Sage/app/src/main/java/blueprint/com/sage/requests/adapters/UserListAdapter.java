package blueprint.com.sage.requests.adapters;

import android.app.Activity;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.List;

import blueprint.com.sage.models.User;
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

    public static class ViewHolder extends RecyclerView.ViewHolder {


        public ViewHolder(View v) {
            super(v);
            ButterKnife.bind(this, v);
        }
    }
}
