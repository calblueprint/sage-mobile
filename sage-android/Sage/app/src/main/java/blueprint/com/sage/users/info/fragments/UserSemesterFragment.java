package blueprint.com.sage.users.info.fragments;

import android.os.Bundle;
import android.support.v7.widget.RecyclerView;

import java.util.HashMap;

import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.users.UserEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.fragments.AbstractCheckInListFragment;
import blueprint.com.sage.users.info.adapters.UserCheckInListAdapter;

/**
 * Created by charlesx on 1/15/16.
 * Shows check ins for a specific user
 */
public class UserSemesterFragment extends AbstractCheckInListFragment {

    private User mUser;
    private Semester mSemester;

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
        return new UserCheckInListAdapter(getActivity(), mUser);
    }

    public void makeCheckInRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("semester_id", String.valueOf(mSemester.getId()));
        queryParams.put("check_ins", "true");
        Requests.Users.with(getActivity()).makeShowRequest(mUser, queryParams);
    }
    
    public void onEvent(UserEvent event) {
        User user = event.getUser();
        setUser(user);
        ((UserCheckInListAdapter) mAdapter).setCheckIns(mUser);
        mCheckInRefreshView.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public void onEvent(APIErrorEvent event) {
        mCheckInRefreshView.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }
}
