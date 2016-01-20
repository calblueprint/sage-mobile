package blueprint.com.sage.admin.semester.fragments;

import android.os.Bundle;
import android.support.v7.widget.RecyclerView;
import android.view.View;

import blueprint.com.sage.admin.browse.adapters.UserListAdapter;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.shared.fragments.AbstractUserListFragment;
import blueprint.com.sage.shared.interfaces.UsersInterface;

/**
 * Created by charlesx on 1/19/16.
 */
public class SemesterUserListFragment extends AbstractUserListFragment {

    private UsersInterface mUsersInterface;

    public static SemesterUserListFragment newInstance() { return new SemesterUserListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mUsersInterface = (UsersInterface) getParentFragment();
    }

    @Override
    public void initializeViews() {
        super.initializeViews();
        mFloatingActionButton.setVisibility(View.GONE);
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
