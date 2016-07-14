package blueprint.com.sage.admin.requests.fragments;

import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.RadioButton;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.requests.adapters.VerifyUserListAdapter;
import blueprint.com.sage.admin.requests.filters.UserAllFilter;
import blueprint.com.sage.admin.requests.filters.UserMySchoolFilter;
import blueprint.com.sage.admin.requests.filters.UserSchoolFilter;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.events.users.DeleteUserEvent;
import blueprint.com.sage.events.users.SignUpNotificationEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.events.users.VerifyUserEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.adapters.spinners.SchoolSpinnerAdapter;
import blueprint.com.sage.shared.fragments.ListFilterFragment;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import blueprint.com.sage.utility.model.SessionUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/14/15.
 * Shows list of unverified users
 */
public class VerifyUsersListFragment extends ListFilterFragment implements OnRefreshListener {

    @Bind(R.id.filter_user_my_school_layout) View mUserMySchoolLayout;
    @Bind(R.id.user_filter_my_school) RadioButton mUserMySchool;
    @Bind(R.id.user_filter_school) RadioButton mUserSchool;
    @Bind(R.id.user_filter_all) RadioButton mUserAll;
    @Bind(R.id.user_filter_school_spinner) Spinner mUserSchoolSpinner;

    @Bind(R.id.verify_user_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.verify_user_list_list) RecycleViewEmpty mUserList;
    @Bind(R.id.verify_user_list_refresh) SwipeRefreshLayout mRefreshUser;
    @Bind(R.id.list_progress_bar) ProgressBar mProgressBar;
    @Bind(R.id.filter_view) View mFilterView;
    @Bind(R.id.list_filter_container) View mFilterContainer;

    private VerifyUserListAdapter mUserAdapter;
    private ToolbarInterface mToolbarInterface;
    private BaseInterface mBaseInterface;

    private List<User> mUsers;
    private List<School> mSchools;
    private SchoolSpinnerAdapter mSchoolsAdapter;

    public static VerifyUsersListFragment newInstance() { return new VerifyUsersListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mToolbarInterface = (ToolbarInterface) getActivity();
        mBaseInterface = (BaseInterface) getActivity();
        mUsers = new ArrayList<>();
        mSchools = new ArrayList<>();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_verify_user_list, parent, false);
        ButterKnife.bind(this, view);

        initializeFilters();
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

    public void initializeFilters() {
        mSchoolsAdapter = new SchoolSpinnerAdapter(getActivity(), mSchools, R.layout.filter_spinner_header, R.layout.filter_spinner_item);
        mUserSchoolSpinner.setAdapter(mSchoolsAdapter);

        UserAllFilter userAllFilter = new UserAllFilter(mUserAll);
        UserSchoolFilter userSchoolFilter = new UserSchoolFilter(mUserSchool, mUserSchoolSpinner);

        mFilterController.addFilters(userAllFilter, userSchoolFilter);

        if (mBaseInterface.getSchool() != null) {
            UserMySchoolFilter userMySchoolFilter = new UserMySchoolFilter(mUserMySchool, mBaseInterface.getSchool());
            mFilterController.addFilters(userMySchoolFilter);
            mFilterController.onFilterChecked(mUserMySchool.getId());
            mUserMySchoolLayout.setVisibility(View.VISIBLE);
        } else {
            mFilterController.onFilterChecked(mUserAll.getId());
        }

        makeSchoolsRequest();
    }

    private void initializeViews() {
        mUserAdapter = new VerifyUserListAdapter(getActivity(), mUsers);

        mUserList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mUserList.setEmptyView(mEmptyView);
        mUserList.setProgressBar(mProgressBar);
        mUserList.setAdapter(mUserAdapter);

        mRefreshUser.setOnRefreshListener(this);
        mEmptyView.setOnRefreshListener(this);

        mToolbarInterface.setTitle("Sign Ups");
        makeUsersListRequest();
    }

    private void makeSchoolsRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("sort[attr]", "lower(name)");
        queryParams.put("sort[order]", "asc");

        Requests.Schools.with(getActivity()).makeListRequest(queryParams);
    }


    public void makeUsersListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("verified", "false");
        queryParams.put("sort_school", "true");
        queryParams.putAll(mFilterController.onFilter());
        Requests.Users.with(getActivity()).makeListRequest(queryParams);
    }

    @Override
    public void onRefresh() { makeUsersListRequest(); }

    public void onEvent(UserListEvent userListEvent) {
        mUsers = userListEvent.getUsers();
        mUserAdapter.setUsers(mUsers);
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

    public void onEvent(SchoolListEvent event) {
        mSchools = event.getSchools();
        mSchoolsAdapter.setSchools(mSchools);
    }

    public void onEvent(APIErrorEvent event) {
        mEmptyView.setRefreshing(false);
        mRefreshUser.setRefreshing(false);
    }

    public void onEvent(final SignUpNotificationEvent event) {
        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mUserAdapter.addUser(event.getUser());
                mUserList.smoothScrollToPosition(0);
            }
        });
    }

    @OnClick({ R.id.user_filter_my_school, R.id.user_filter_school, R.id.user_filter_all })
    public void onRadioButtonClick(View view) {
        mFilterController.onFilterChecked(view.getId());
    }

    @Override
    @OnClick(R.id.filter_view)
    public void onFilterViewShow() {
        mFilterController.showFilter(getActivity(), mFilterContainer);
    }

    @Override
    @OnClick(R.id.filter_cancel)
    public void onFilterViewHide() {
        mFilterController.hideFilter(getActivity(), mFilterContainer);
    }

    @Override
    @OnClick(R.id.filter_confirm)
    public void onFilterClick() {
        mEmptyView.setRefreshing(true);
        mRefreshUser.setRefreshing(true);
        makeUsersListRequest();
        onFilterViewHide();
    }
}
