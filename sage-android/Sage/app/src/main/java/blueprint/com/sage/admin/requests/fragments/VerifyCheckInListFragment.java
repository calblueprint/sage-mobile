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
import blueprint.com.sage.admin.requests.adapters.VerifyCheckInListAdapter;
import blueprint.com.sage.admin.requests.filters.CheckInAllFilter;
import blueprint.com.sage.admin.requests.filters.CheckInSchoolFilter;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.checkIns.CheckInListEvent;
import blueprint.com.sage.events.checkIns.DeleteCheckInEvent;
import blueprint.com.sage.events.checkIns.VerifyCheckInEvent;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.adapters.spinners.SchoolSpinnerAdapter;
import blueprint.com.sage.shared.fragments.ListFilterFragment;
import blueprint.com.sage.shared.interfaces.CheckInsInterface;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import blueprint.com.sage.utility.model.SessionUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/10/15.
 * Gets list of unverified checkins
 */
public class VerifyCheckInListFragment extends ListFilterFragment implements OnRefreshListener {

    @Bind(R.id.verify_check_in_list_refresh) SwipeRefreshLayout mCheckInRefreshLayout;
    @Bind(R.id.verify_check_in_list_list) RecycleViewEmpty mCheckInList;
    @Bind(R.id.verify_check_in_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.list_progress_bar) ProgressBar mProgressBar;

    @Bind(R.id.check_in_filter_all) RadioButton mCheckInFilterAll;
    @Bind(R.id.check_in_filter_school) RadioButton mCheckInSchoolButton;
    @Bind(R.id.check_in_filter_school_spinner) Spinner mCheckInSchoolSpinner;

    private VerifyCheckInListAdapter mCheckInAdapter;

    private CheckInsInterface mCheckInInterface;
    private ToolbarInterface mToolbarInterface;

    private List<School> mSchools;
    private SchoolSpinnerAdapter mSchoolsAdapter;

    public static VerifyCheckInListFragment newInstance() { return new VerifyCheckInListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mCheckInInterface = (CheckInsInterface) getActivity();
        mToolbarInterface = (ToolbarInterface) getActivity();
        mSchools = new ArrayList<>();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_verify_check_in_list, parent, false);
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
        mCheckInAdapter = new VerifyCheckInListAdapter(getActivity(), mCheckInInterface.getCheckIns());

        mCheckInList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mCheckInList.setEmptyView(mEmptyView);
        mCheckInList.setProgressBar(mProgressBar);
        mCheckInList.setAdapter(mCheckInAdapter);

        mCheckInRefreshLayout.setOnRefreshListener(this);
        mEmptyView.setOnRefreshListener(this);

        mToolbarInterface.setTitle("Check Ins");
    }

    public void initializeFilters() {
        CheckInAllFilter checkInAllFilter = new CheckInAllFilter(mCheckInFilterAll);
        CheckInSchoolFilter checkInSchoolFilter = new CheckInSchoolFilter(mCheckInSchoolButton, mCheckInSchoolSpinner);
        mFilterController.addFilters(checkInAllFilter, checkInSchoolFilter);

        mSchoolsAdapter = new SchoolSpinnerAdapter(getActivity(), mSchools, R.layout.filter_spinner_header, R.layout.filter_spinner_item);

        makeSchoolsRequest();
    }

    public void makeSchoolsRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("sort[attr]", "lower(name)");
        queryParams.put("sort[order]", "asc");
        Requests.Schools.with(getActivity()).makeListRequest(queryParams);
    }

    @Override
    public void onRefresh() { mCheckInInterface.getCheckInListRequest(); }

    public void onEvent(CheckInListEvent event) {
        mCheckInInterface.setCheckIns(event.getCheckIns());
        mCheckInAdapter.setCheckIns(mCheckInInterface.getCheckIns());
        mCheckInRefreshLayout.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public void onEvent(DeleteCheckInEvent event) {
        int position = event.getPosition();
        mCheckInAdapter.removeCheckIn(position);
        SessionUtils.updateRequestCount(getActivity(), -1, R.string.admin_check_in_requests);
    }

    public void onEvent(VerifyCheckInEvent event) {
        int position = event.getPosition();
        mCheckInAdapter.removeCheckIn(position);
        SessionUtils.updateRequestCount(getActivity(), -1, R.string.admin_check_in_requests);
    }

    public void onEvent(APIErrorEvent event) {
        mCheckInRefreshLayout.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public void onEvent(SchoolListEvent event) {
        mSchools = event.getSchools();
        mSchoolsAdapter.setSchools(mSchools);
    }

    public void onFilterClick() {

    }
}
