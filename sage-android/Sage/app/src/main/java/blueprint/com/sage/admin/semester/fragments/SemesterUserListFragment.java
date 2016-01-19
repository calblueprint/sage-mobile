package blueprint.com.sage.admin.semester.fragments;

import android.os.Bundle;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.browse.fragments.UserListFragment;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.semesters.SemesterEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.shared.fragments.AbstractUserListFragment;
import blueprint.com.sage.shared.interfaces.UsersInterface;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 1/19/16.
 */
public class SemesterUserListFragment extends AbstractUserListFragment {

    private UsersInterface mUsersInterface;

    public static UserListFragment newInstance() { return new UserListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mUsersInterface = (UsersInterface) getActivity();
    }

    @Override
    public void initializeViews() {
        super.initializeViews();
        mFloatingActionButton.setVisibility(View.GONE);
    }

    public void makeUserListRequest() { mUsersInterface.getUsersListRequest(); }

    public RecyclerView.Adapter getAdapter() {

    }

    public void onEvent(SemesterEvent event) {
        Semester userSemesters = event.getSemester();
    }

    public void onEvent(UserListEvent event) {
        mUsersInterface.setUsers(event.getUsers());

//        mUserListAdapter.setUsers(mUsersInterface.getUsers());

        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public void onEvent(APIErrorEvent event) {
        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }
}
