package blueprint.com.sage.schools.fragments;

import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.events.SchoolListEvent;
import blueprint.com.sage.schools.adapters.SchoolsAdapter;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 11/4/15.
 * Shows a list of schools
 */
public class SchoolListFragment extends SchoolAbstractFragment implements OnRefreshListener {

    @Bind(R.id.schools_list_list) RecycleViewEmpty mSchoolsList;
    @Bind(R.id.schools_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.schools_list_refresh) SwipeRefreshLayout mSchoolsRefreshView;

    private SchoolsAdapter mAdapter;

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

    private void initializeViews() {
        mAdapter = new SchoolsAdapter(getActivity(), R.layout.schools_list_item, getParentActivity().getSchools());

        mSchoolsList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mSchoolsList.setEmptyView(mEmptyView);
        mSchoolsList.setAdapter(mAdapter);

        mEmptyView.setOnRefreshListener(this);
        mSchoolsRefreshView.setOnRefreshListener(this);
    }

    @Override
    public void onRefresh() { getParentActivity().getSchoolsListRequest(); }

    public void onMessage(SchoolListEvent event) {
        mAdapter.setSchools(getParentActivity().getSchools());
    }
}
