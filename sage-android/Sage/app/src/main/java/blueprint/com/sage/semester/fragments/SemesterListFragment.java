package blueprint.com.sage.semester.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.adapters.UserListAdapter;
import blueprint.com.sage.events.semesters.SemesterListEvent;
import blueprint.com.sage.network.Requests;
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

    private UserListAdapter mUserListAdapter;

    public static SemesterListFragment newInstance() { return new SemesterListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
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

    }

    public void onRefresh() {

    }

    public void onEvent(SemesterListEvent event) {

    }
}
