package blueprint.com.sage.semester.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.semesters.SemesterListEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.semester.adapters.SemesterListAdapter;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 1/7/16.
 * Shows a list of semesters
 */
public class SemesterListFragment extends Fragment implements SwipeRefreshLayout.OnRefreshListener {

    @Bind(R.id.user_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.user_list_list) RecycleViewEmpty mSemesterList;
    @Bind(R.id.user_list_refresh) SwipeRefreshLayout mRefreshSemesters;

    private List<Semester> mSemesters;
    private SemesterListAdapter mSemesterListAdapter;

    public static SemesterListFragment newInstance() { return new SemesterListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mSemesters = new ArrayList<>();
        Requests.Semesters.with(getActivity()).makeListRequest(null);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_semester_list, parent, false);
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
        mSemesterListAdapter = new SemesterListAdapter(getActivity(), mSemesters);
        mSemesterList.setAdapter(mSemesterListAdapter);
        mSemesterList.setEmptyView(mEmptyView);
        mSemesterList.setLayoutManager(new LinearLayoutManager(getActivity()));

        mRefreshSemesters.setOnRefreshListener(this);
        mEmptyView.setOnRefreshListener(this);

        getActivity().setTitle("Semesters");
    }

    public void onRefresh() {
        Requests.Semesters.with(getActivity()).makeListRequest(null);
    }

    public void onEvent(SemesterListEvent event) {
        mSemesters = event.getSemesters();
        mSemesterListAdapter.setSemesters(mSemesters);
        mRefreshSemesters.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }
}
