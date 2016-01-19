package blueprint.com.sage.users.info.fragments;

import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.RecyclerView;
import android.util.Log;

import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.user_semesters.UserSemesterListEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
import blueprint.com.sage.models.UserSemester;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.fragments.AbstractCheckInListFragment;
import blueprint.com.sage.users.info.adapters.UserCheckInListAdapter;

/**
 * Created by charlesx on 1/15/16.
 * Shows check ins for a specific user
 */
public class UserSemesterFragment extends AbstractCheckInListFragment implements SwipeRefreshLayout.OnRefreshListener {

    private User mUser;
    private Semester mSemester;
    private UserSemester mUserSemester;

    public static UserSemesterFragment newInstance(User user, Semester semester) {
        UserSemesterFragment fragment = new UserSemesterFragment();
        fragment.setUser(user);
        fragment.setSemester(semester);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }
    public void setSemester(Semester semester) { mSemester = semester; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        makeCheckInRequest();
    }

    public RecyclerView.Adapter getAdapter() {
        return new UserCheckInListAdapter(getActivity(), mUserSemester);
    }

    public void makeCheckInRequest() {
        HashMap<String, String> queryRequests = new HashMap<>();
        queryRequests.put("user_id", String.valueOf(mUser.getId()));
        queryRequests.put("semester_id", String.valueOf(mSemester.getId()));
        Requests.UserSemesters.with(getActivity()).makeListRequest(queryRequests);
    }
    
    public void onEvent(UserSemesterListEvent event) {
        List<UserSemester> userSemesters = event.getUserSemesters();

        if (userSemesters.size() == 0) {
            Log.e(getClass().toString(), "No user semester");
            return;
        }
        mUserSemester = event.getUserSemesters().get(0);
        ((UserCheckInListAdapter) mAdapter).setCheckIns(mUserSemester);
    }

    public void onEvent(APIErrorEvent event) {
        mRefreshUsers.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }
}
