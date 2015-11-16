package blueprint.com.sage.requests.fragments;

import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.events.users.DeleteUserEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.events.users.VerifyUserEvent;
import blueprint.com.sage.requests.adapters.UserListAdapter;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/14/15.
 */
public class UnverifiedUsersListFragment extends RequestsAbstractFragment implements OnRefreshListener {

    @Bind(R.id.user_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.user_list_list) RecycleViewEmpty mUserList;
    @Bind(R.id.user_list_refresh) SwipeRefreshLayout mRefreshUser;

    private UserListAdapter mUserAdapter;

    public static UnverifiedUsersListFragment newInstance() { return new UnverifiedUsersListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) { super.onCreate(savedInstanceState); }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user_list, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    private void initializeViews() {
        mUserAdapter = new UserListAdapter(getParentActivity(), R.layout.users_list_item, getParentActivity().getUsers());

        mUserList.setLayoutManager(new LinearLayoutManager(getParentActivity()));
        mUserList.setEmptyView(mEmptyView);
        mUserList.setAdapter(mUserAdapter);

        mRefreshUser.setOnRefreshListener(this);
        mEmptyView.setOnRefreshListener(this);
    }

    @Override
    public void onRefresh() { getParentActivity().makeUsersListRequest(); }

    public void onEvent(UserListEvent userListEvent) {
        mUserAdapter.setUsers(getParentActivity().getUsers());
        mEmptyView.setRefreshing(false);
        mRefreshUser.setRefreshing(false);
    }

    public void onEvent(VerifyUserEvent verifyUserEvent) {
        mUserAdapter.removeUser(verifyUserEvent.getPosition());
    }

    public void onEvent(DeleteUserEvent deleteUserRequest) {
        mUserAdapter.removeUser(deleteUserRequest.getPosition());
    }
}
