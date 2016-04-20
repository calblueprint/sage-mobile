package blueprint.com.sage.admin.browse.fragments;

import android.os.Bundle;
import android.support.v7.widget.RecyclerView;

import java.util.List;

import blueprint.com.sage.admin.browse.adapters.BrowseUserListAdapter;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.fragments.AbstractUserListFragment;
import blueprint.com.sage.shared.interfaces.UsersInterface;

/**
 * Created by charlesx on 11/17/15.
 */
public class BrowseUserListFragment extends AbstractUserListFragment {

    private UsersInterface mUsersInterface;

    public static BrowseUserListFragment newInstance() { return new BrowseUserListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mUsersInterface = (UsersInterface) getActivity();
        makeUserListRequest();
    }

    @Override
    public void initializeViews() {
        super.initializeViews();
        mToolbarInterface.setTitle("Users");
    }

    public void makeUserListRequest() { mUsersInterface.getUsersListRequest(); }

    public RecyclerView.Adapter getAdapter() {
        return new BrowseUserListAdapter(getActivity(), mUsersInterface.getUsers());
    }

    public void onEvent(UserListEvent event) {
        List<User> list = event.getUsers();
        mUsersInterface.setUsers(event.getUsers());
        ((BrowseUserListAdapter) mUserListAdapter).setUsers(mUsersInterface.getUsers());
        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public void onEvent(APIErrorEvent event) {
        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }
}
