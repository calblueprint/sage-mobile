package blueprint.com.sage.browse.fragments;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.adapters.UserListAdapter;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/17/15.
 */
public class UserListFragment extends BrowseAbstractFragment implements OnRefreshListener{

    @Bind(R.id.user_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.user_list_list) RecycleViewEmpty mUserList;
    @Bind(R.id.user_list_refresh) SwipeRefreshLayout mRefreshUsers;

    private UserListAdapter mUserListAdapter;

    public static UserListFragment newInstance() { return new UserListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user_list, parent, false);
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

    @Override
    public void onRefresh() {
        getParentActivity().getUsersListRequest();
    }

    private void initializeViews() {
        getParentActivity().getUsersListRequest();

        mUserListAdapter = new UserListAdapter(getParentActivity(), getParentActivity().getUsers());

        mUserList.setLayoutManager(new LinearLayoutManager(getParentActivity()));
        mUserList.setEmptyView(mEmptyView);
        mUserList.setAdapter(mUserListAdapter);

        mRefreshUsers.setOnRefreshListener(this);
        mEmptyView.setOnRefreshListener(this);
    }

    public void onEvent(UserListEvent event) {
        getParentActivity().setUsers(event.getUsers());
        mUserListAdapter.setUsers(getParentActivity().getUsers());
        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    @OnClick(R.id.user_list_fab)
    public void onCreateAdminClick(FloatingActionButton button) {
        FragUtils.replaceBackStack(R.id.container, CreateAdminFragment.newInstance(), getParentActivity());
    }
}
