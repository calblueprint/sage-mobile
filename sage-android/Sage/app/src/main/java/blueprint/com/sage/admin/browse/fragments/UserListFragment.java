package blueprint.com.sage.admin.browse.fragments;

import android.os.Bundle;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.browse.adapters.UserListAdapter;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.shared.fragments.AbstractUserListFragment;
import blueprint.com.sage.shared.interfaces.UsersInterface;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/17/15.
 */
public class UserListFragment extends AbstractUserListFragment {

    private UsersInterface mUsersInterface;

    public static UserListFragment newInstance() { return new UserListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mUsersInterface = (UsersInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user_list, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    public void makeUserListRequest() { mUsersInterface.getUsersListRequest(); }

    public RecyclerView.Adapter getAdapter() {
        return new UserListAdapter(getActivity(), mUsersInterface.getUsers());
    }

    public void onEvent(UserListEvent event) {
        mUsersInterface.setUsers(event.getUsers());
        ((UserListAdapter) mUserListAdapter).setUsers(mUsersInterface.getUsers());
        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public void onEvent(APIErrorEvent event) {
        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }
}
