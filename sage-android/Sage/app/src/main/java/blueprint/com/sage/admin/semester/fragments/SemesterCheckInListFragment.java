package blueprint.com.sage.admin.semester.fragments;

import android.os.Bundle;
import android.support.v7.widget.RecyclerView;

import java.util.List;

import blueprint.com.sage.admin.semester.adapters.SemesterCheckInListAdapter;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.checkIns.CheckInListEvent;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.shared.fragments.AbstractCheckInListFragment;
import blueprint.com.sage.shared.interfaces.CheckInsInterface;

/**
 * Created by charlesx on 1/19/16.
 */
public class SemesterCheckInListFragment extends AbstractCheckInListFragment {

    private CheckInsInterface mCheckInInterface;

    public static SemesterCheckInListFragment newInstance() { return new SemesterCheckInListFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mCheckInInterface = (CheckInsInterface) getParentFragment();
    }

    public void makeCheckInRequest() { mCheckInInterface.getCheckIns(); }

    public RecyclerView.Adapter getAdapter() {
        return new SemesterCheckInListAdapter(getActivity(), mCheckInInterface.getCheckIns());
    }

    public void onEvent(CheckInListEvent event) {
        List<CheckIn> checkIns = event.getCheckIns();
        mCheckInInterface.setCheckIns(checkIns);
        ((SemesterCheckInListAdapter) mAdapter).setCheckIns(checkIns);
        mCheckInRefreshView.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }

    public void onEvent(APIErrorEvent event) {
        mCheckInRefreshView.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }
}
