package blueprint.com.sage.requests.fragments;

import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.events.users.DeleteUserEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.events.users.VerifyUserEvent;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/14/15.
 */
public class UnverifiedUsersListFragment extends RequestsAbstractFragment {

    @Bind(R.id.user_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.user_list_list) RecycleViewEmpty mUserList;
    @Bind(R.id.user_list_refresh) SwipeRefreshLayout mRefreshUser;

    public static UnverifiedUsersListFragment newInstance() { return new UnverifiedUsersListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) { super.onCreate(savedInstanceState); }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user_list, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }

    public void onEvent(UserListEvent userListEvent) {

    }

    public void onEvent(VerifyUserEvent verifyUserEvent) {

    }

    public void onEvent(DeleteUserEvent deleteUserRequest) {

    }
}
