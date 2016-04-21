package blueprint.com.sage.admin.requests.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;

import blueprint.com.sage.R;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.users.DeleteUserEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.events.users.VerifyUserEvent;
import blueprint.com.sage.admin.requests.adapters.VerifyUserListAdapter;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.shared.interfaces.UsersInterface;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import blueprint.com.sage.utility.model.SessionUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/14/15.
 * Shows list of unverified users
 */
public class VerifyUsersListFragment extends Fragment implements OnRefreshListener {

    @Bind(R.id.verify_user_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.verify_user_list_list) RecycleViewEmpty mUserList;
    @Bind(R.id.verify_user_list_refresh) SwipeRefreshLayout mRefreshUser;
    @Bind(R.id.list_progress_bar) ProgressBar mProgressBar;

    private VerifyUserListAdapter mUserAdapter;
    private UsersInterface mUsersInterface;
    private ToolbarInterface mToolbarInterface;

    public static VerifyUsersListFragment newInstance() { return new VerifyUsersListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mUsersInterface = (UsersInterface) getActivity();
        mToolbarInterface = (ToolbarInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_verify_user_list, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    private void initializeViews() {
        mUserAdapter = new VerifyUserListAdapter(getActivity(), mUsersInterface.getUsers());

        mUserList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mUserList.setEmptyView(mEmptyView);
        mUserList.setProgressBar(mProgressBar);
        mUserList.setAdapter(mUserAdapter);

        mRefreshUser.setOnRefreshListener(this);
        mEmptyView.setOnRefreshListener(this);

        mToolbarInterface.setTitle("Sign Ups");
    }

    @Override
    public void onRefresh() { mUsersInterface.getUsersListRequest(); }

    public void onEvent(UserListEvent userListEvent) {
        mUsersInterface.setUsers(userListEvent.getUsers());
        mUserAdapter.setUsers(mUsersInterface.getUsers());
        mEmptyView.setRefreshing(false);
        mRefreshUser.setRefreshing(false);
    }

    public void onEvent(VerifyUserEvent verifyUserEvent) {
        mUserAdapter.removeUser(verifyUserEvent.getPosition());
        SessionUtils.updateRequestCount(getActivity(), -1, R.string.admin_sign_up_requests);
    }

    public void onEvent(DeleteUserEvent deleteUserRequest) {
        mUserAdapter.removeUser(deleteUserRequest.getPosition());
        SessionUtils.updateRequestCount(getActivity(), -1, R.string.admin_sign_up_requests);
    }

    public void onEvent(APIErrorEvent event) {
        mEmptyView.setRefreshing(false);
        mRefreshUser.setRefreshing(false);
    }
}
