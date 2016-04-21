package blueprint.com.sage.admin.browse.fragments;

import android.os.Bundle;
import android.support.v7.widget.RecyclerView;

import java.util.HashMap;

import blueprint.com.sage.admin.browse.adapters.BrowseUserListAdapter;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.fragments.AbstractUserListFragment;

/**
 * Created by charlesx on 11/17/15.
 */
public class BrowseUserListFragment extends AbstractUserListFragment {

    public static BrowseUserListFragment newInstance() { return new BrowseUserListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        makeUserListRequest();
    }

    @Override
    public void initializeViews() {
        super.initializeViews();
        mToolbarInterface.setTitle("Users");
    }

    public void makeUserListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("current_semester", "true");
        queryParams.put("sort_name", "true");
        queryParams.put("page", "" + mPaginationInstance.getCurrentPage());
        Requests.Users.with(getActivity()).makeListRequest(queryParams);
    }

    public RecyclerView.Adapter getAdapter() {
        return new BrowseUserListAdapter(getActivity(), mUsers);
    }

    public void onEvent(UserListEvent event) {
        mUsers = event.getUsers();
        ((BrowseUserListAdapter) mUserListAdapter).setUsers(mUsers);
        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public void onEvent(APIErrorEvent event) {
        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }
}
