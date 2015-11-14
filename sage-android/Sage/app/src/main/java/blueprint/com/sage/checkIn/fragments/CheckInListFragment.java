package blueprint.com.sage.checkIn.fragments;

import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.checkIn.CheckInListAdapter;
import blueprint.com.sage.events.checkIns.CheckInListEvent;
import blueprint.com.sage.events.checkIns.DeleteCheckInEvent;
import blueprint.com.sage.events.checkIns.VerifyCheckInEvent;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/10/15.
 */
public class CheckInListFragment extends CheckInListAbstractFragment implements OnRefreshListener {

    @Bind(R.id.check_in_list_refresh) SwipeRefreshLayout mCheckInRefreshLayout;
    @Bind(R.id.check_in_list_list) RecycleViewEmpty mCheckInList;
    @Bind(R.id.check_in_list_empty_view) SwipeRefreshLayout mEmptyView;

    private CheckInListAdapter mCheckInAdapter;

    public static CheckInListFragment newInstance() { return new CheckInListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_check_in_list, parent, false);
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
        mCheckInAdapter = new CheckInListAdapter(getParentActivity(),
                                                 R.layout.check_in_list_item,
                                                 getParentActivity().getCheckIns());

        mCheckInList.setLayoutManager(new LinearLayoutManager(getParentActivity()));
        mCheckInList.setEmptyView(mEmptyView);
        mCheckInList.setAdapter(mCheckInAdapter);

        mCheckInRefreshLayout.setOnRefreshListener(this);
        mEmptyView.setOnRefreshListener(this);
    }

    @Override
    public void onRefresh() { getParentActivity().makeCheckInListRequest(); }

    public void onEvent(CheckInListEvent event) {
        mCheckInAdapter.setCheckIns(getParentActivity().getCheckIns());
        mCheckInRefreshLayout.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public void onEvent(DeleteCheckInEvent event) {
        int position = event.getPosition();
        mCheckInAdapter.notifyItemRemoved(position);
    }

    public void onEvent(VerifyCheckInEvent event) {
        int position = event.getPosition();
        mCheckInAdapter.notifyItemRemoved(position);
    }
}
