package blueprint.com.sage.shared.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.semesters.SemesterListEvent;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.shared.adapters.models.AbstractSemesterListAdapter;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 1/7/16.
 * Shows a list of semesters
 */
public abstract class AbstractSemesterListFragment extends Fragment implements SwipeRefreshLayout.OnRefreshListener {

    @Bind(R.id.semester_list_empty_view) SwipeRefreshLayout mEmptyView;
    @Bind(R.id.semester_list_list) RecycleViewEmpty mSemesterList;
    @Bind(R.id.semester_list_refresh) SwipeRefreshLayout mRefreshSemesters;
    @Bind(R.id.list_progress_bar) ProgressBar mProgressBar;

    public List<Semester> mSemesters;
    public AbstractSemesterListAdapter mSemesterListAdapter;

    private ToolbarInterface mToolbarInterface;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mSemesters = new ArrayList<>();
        mToolbarInterface = (ToolbarInterface) getActivity();
        makeSemesterListRequest();
    }

    public abstract void makeSemesterListRequest();

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
        mSemesterListAdapter = getAdapter();
        mSemesterList.setEmptyView(mEmptyView);
        mSemesterList.setProgressBar(mProgressBar);
        mSemesterList.setAdapter(mSemesterListAdapter);
        mSemesterList.setLayoutManager(new LinearLayoutManager(getActivity()));

        mRefreshSemesters.setOnRefreshListener(this);
        mEmptyView.setOnRefreshListener(this);

        mToolbarInterface.setTitle("Semesters");
    }

    public abstract AbstractSemesterListAdapter getAdapter();

    public void onRefresh() { makeSemesterListRequest(); }

    public void onEvent(SemesterListEvent event) {
        mSemesters = event.getSemesters();
        mSemesterListAdapter.setSemesters(mSemesters);
        mRefreshSemesters.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public void onEvent(APIError event) {
        mRefreshSemesters.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }
}
