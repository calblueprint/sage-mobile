package blueprint.com.sage.users.info.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.user_semesters.UserSemesterListEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
import blueprint.com.sage.models.UserSemester;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import blueprint.com.sage.users.info.adapters.UserCheckInListAdapter;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 1/15/16.
 */
public class UserSemesterFragment extends Fragment implements SwipeRefreshLayout.OnRefreshListener {

    @Bind(R.id.user_check_in_list) RecycleViewEmpty mCheckInList;
    @Bind(R.id.user_check_in_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.user_check_in_refresh) SwipeRefreshLayout mCheckInRefreshView;
    
    private User mUser;
    private Semester mSemester;
    private UserSemester mUserSemester;

    private UserCheckInListAdapter mAdapter;

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
        makeUserSemesterRequest();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user_semester, parent, false);
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
    public void onRefresh() { makeUserSemesterRequest(); }

    private void makeUserSemesterRequest() {
        HashMap<String, String> queryRequests = new HashMap<>();
        queryRequests.put("user_id", String.valueOf(mUser.getId()));
        queryRequests.put("semester_id", String.valueOf(mSemester.getId()));
        Requests.UserSemesters.with(getActivity()).makeListRequest(queryRequests);
    }

    private void initializeViews() {
        mAdapter = new UserCheckInListAdapter(getActivity(), mUserSemester);
        mCheckInList.setEmptyView(mEmptyView);
        mCheckInList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mCheckInList.setAdapter(mAdapter);

        mCheckInRefreshView.setOnRefreshListener(this);
    }
    
    public void onEvent(UserSemesterListEvent event) {
        List<UserSemester> userSemesters = event.getUserSemesters();

        if (userSemesters.size() == 0) {
            Log.e(getClass().toString(), "No user semester");
            return;
        }

        mAdapter.setCheckIns(event.getUserSemesters().get(0));
    }
}
