package blueprint.com.sage.shared.fragments;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import blueprint.com.sage.users.profile.fragments.CreateAdminFragment;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/17/15.
 */
public abstract class AbstractUserListFragment extends Fragment implements OnRefreshListener {

    @Bind(R.id.user_list_empty_view) public SwipeRefreshLayout mEmptyView;
    @Bind(R.id.user_list_list) public RecycleViewEmpty mUserList;
    @Bind(R.id.user_list_refresh) public SwipeRefreshLayout mRefreshUsers;
    @Bind(R.id.user_list_fab) public FloatingActionButton mFloatingActionButton;

    public RecyclerView.Adapter mUserListAdapter;

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
    public void onRefresh() { makeUserListRequest(); }

    public void initializeViews() {
        mUserListAdapter = getAdapter();

        mUserList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mUserList.setEmptyView(mEmptyView);
        mUserList.setAdapter(mUserListAdapter);

        mRefreshUsers.setOnRefreshListener(this);
        mEmptyView.setOnRefreshListener(this);

        getActivity().setTitle("Users");
    }

    @OnClick(R.id.user_list_fab)
    public void onCreateAdminClick(FloatingActionButton button) {
        FragUtils.replaceBackStack(R.id.container, CreateAdminFragment.newInstance(), getActivity());
    }

    public void onEvent(APIErrorEvent event) {
        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public abstract void makeUserListRequest();
    public abstract RecyclerView.Adapter getAdapter();
}
