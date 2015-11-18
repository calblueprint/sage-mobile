package blueprint.com.sage.schools.fragments;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.schools.adapters.SchoolsListAdapter;
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
public class SchoolListFragment extends SchoolAbstractFragment implements OnRefreshListener {

    @Bind(R.id.schools_list_list) RecycleViewEmpty mSchoolsList;
    @Bind(R.id.schools_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.schools_list_refresh) SwipeRefreshLayout mSchoolsRefreshView;
    @Bind(R.id.school_list_fab) FloatingActionButton mCreateButton;

    private SchoolsListAdapter mAdapter;

    public static SchoolListFragment newInstance() { return new SchoolListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) { super.onCreate(savedInstanceState); }

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
        mAdapter = new SchoolsListAdapter(getActivity(), R.layout.schools_list_item, getParentActivity().getSchools());

        mSchoolsList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mSchoolsList.setEmptyView(mEmptyView);
        mSchoolsList.setAdapter(mAdapter);

        mEmptyView.setOnRefreshListener(this);
        mSchoolsRefreshView.setOnRefreshListener(this);
    }

    @Override
    public void onRefresh() { getParentActivity().getSchoolsListRequest(); }

    public void onEvent(SchoolListEvent event) {
        getParentActivity().setSchools(event.getSchools());
        mAdapter.setSchools(getParentActivity().getSchools());
        mEmptyView.setRefreshing(false);
        mSchoolsRefreshView.setRefreshing(false);
    }

    @OnClick(R.id.school_list_fab)
    public void onCreateClick(FloatingActionButton button) {
        FragUtils.replaceBackStack(R.id.container, CreateSchoolFragment.newInstance(), getParentActivity());
    }
}
