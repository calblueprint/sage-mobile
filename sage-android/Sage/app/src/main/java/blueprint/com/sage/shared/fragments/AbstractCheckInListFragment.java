package blueprint.com.sage.shared.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;

import blueprint.com.sage.R;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.shared.interfaces.ToolbarInterface;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 1/19/16.
 */
public abstract class AbstractCheckInListFragment extends Fragment implements SwipeRefreshLayout.OnRefreshListener{

    @Bind(R.id.user_check_in_list) public RecycleViewEmpty mCheckInList;
    @Bind(R.id.user_check_in_empty_view) public SwipeRefreshLayout mEmptyView;
    @Bind(R.id.user_check_in_refresh) public SwipeRefreshLayout mCheckInRefreshView;
    @Bind(R.id.list_progress_bar) ProgressBar mProgressBar;

    public RecyclerView.Adapter mAdapter;
    public ToolbarInterface mToolbarInterface;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mToolbarInterface = (ToolbarInterface) getActivity();
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
    public void onRefresh() { makeCheckInRequest(); }

    public void initializeViews() {
        mAdapter = getAdapter();
        mCheckInList.setEmptyView(mEmptyView);
        mCheckInList.setProgressBar(mProgressBar);
        mCheckInList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mCheckInList.setAdapter(mAdapter);

        mCheckInRefreshView.setOnRefreshListener(this);

        mToolbarInterface.setTitle("Check Ins");
    }

    public void onEvent(APIErrorEvent event) {
        mCheckInRefreshView.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public abstract RecyclerView.Adapter getAdapter();
    public abstract void makeCheckInRequest();
}
