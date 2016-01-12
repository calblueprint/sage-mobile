package blueprint.com.sage.browse.fragments;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.HashMap;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.adapters.SchoolsListAdapter;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.SchoolsInterface;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/4/15.
 * Shows a list of schools
 */
public class SchoolListFragment extends Fragment implements OnRefreshListener {

    @Bind(R.id.schools_list_list) RecycleViewEmpty mSchoolsList;
    @Bind(R.id.schools_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.schools_list_refresh) SwipeRefreshLayout mSchoolsRefreshView;
    @Bind(R.id.school_list_fab) FloatingActionButton mCreateButton;

    private SchoolsListAdapter mAdapter;
    private SchoolsInterface mSchoolsInterface;

    public static SchoolListFragment newInstance() { return new SchoolListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mSchoolsInterface = (SchoolsInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_schools_list, parent, false);
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
        mAdapter = new SchoolsListAdapter(getActivity(), R.layout.schools_list_item, mSchoolsInterface.getSchools());

        mSchoolsList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mSchoolsList.setEmptyView(mEmptyView);
        mSchoolsList.setAdapter(mAdapter);

        mEmptyView.setOnRefreshListener(this);
        mSchoolsRefreshView.setOnRefreshListener(this);

        getActivity().setTitle("Schools");
        getSchoolsListRequest();
    }

    @Override
    public void onRefresh() { getSchoolsListRequest(); }

    public void getSchoolsListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("sort[attr]", "lower(name)");
        queryParams.put("sort[order]", "asc");
        Requests.Schools.with(getActivity()).makeListRequest(queryParams);
    }

    @OnClick(R.id.school_list_fab)
    public void onCreateClick(FloatingActionButton button) {
        FragUtils.replaceBackStack(R.id.container, CreateSchoolFragment.newInstance(), getActivity());
    }

    public void onEvent(SchoolListEvent event) {
        mSchoolsInterface.setSchools(event.getSchools());
        mAdapter.setSchools(mSchoolsInterface.getSchools());
        mEmptyView.setRefreshing(false);
        mSchoolsRefreshView.setRefreshing(false);
    }

    public void onEvent(APIErrorEvent event) {
        mEmptyView.setRefreshing(false);
        mSchoolsRefreshView.setRefreshing(false);
    }
}
