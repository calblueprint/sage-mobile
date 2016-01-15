package blueprint.com.sage.admin.requests.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v4.widget.SwipeRefreshLayout.OnRefreshListener;
import android.support.v7.widget.LinearLayoutManager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.events.checkIns.CheckInListEvent;
import blueprint.com.sage.events.checkIns.DeleteCheckInEvent;
import blueprint.com.sage.events.checkIns.VerifyCheckInEvent;
import blueprint.com.sage.admin.requests.adapters.VerifyCheckInListAdapter;
import blueprint.com.sage.shared.interfaces.CheckInsInterface;
import blueprint.com.sage.shared.views.RecycleViewEmpty;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/10/15.
 * Gets list of unverified checkins
 */
public class VerifyCheckInListFragment extends Fragment implements OnRefreshListener {

    @Bind(R.id.verify_check_in_list_refresh) SwipeRefreshLayout mCheckInRefreshLayout;
    @Bind(R.id.verify_check_in_list_list) RecycleViewEmpty mCheckInList;
    @Bind(R.id.verify_check_in_list_empty_view) SwipeRefreshLayout mEmptyView;

    private VerifyCheckInListAdapter mCheckInAdapter;

    private CheckInsInterface mCheckInInterface;

    public static VerifyCheckInListFragment newInstance() { return new VerifyCheckInListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mCheckInInterface = (CheckInsInterface) getActivity();
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
        mCheckInAdapter = new VerifyCheckInListAdapter(getActivity(),
                                                 R.layout.verify_check_in_list_item,
                                                 mCheckInInterface.getCheckIns());

        mCheckInList.setLayoutManager(new LinearLayoutManager(getActivity()));
        mCheckInList.setEmptyView(mEmptyView);
        mCheckInList.setAdapter(mCheckInAdapter);

        mCheckInRefreshLayout.setOnRefreshListener(this);
        mEmptyView.setOnRefreshListener(this);

        getActivity().setTitle("Check Ins");
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
    }

    public void onEvent(VerifyCheckInEvent event) {
        int position = event.getPosition();
        mCheckInAdapter.removeCheckIn(position);
    }
}
