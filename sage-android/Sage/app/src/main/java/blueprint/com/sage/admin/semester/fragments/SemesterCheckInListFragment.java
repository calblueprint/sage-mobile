package blueprint.com.sage.admin.semester.fragments;

import android.os.Bundle;
import android.support.v7.widget.RecyclerView;
import android.util.Log;

import java.util.List;

import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.checkIns.CheckInListEvent;
import blueprint.com.sage.events.semesters.SemesterEvent;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.UserSemester;
import blueprint.com.sage.shared.fragments.AbstractCheckInListFragment;
import blueprint.com.sage.shared.interfaces.CheckInsInterface;

/**
 * Created by charlesx on 1/19/16.
 */
public class SemesterCheckInListFragment extends AbstractCheckInListFragment {

    private CheckInsInterface mCheckInInterface;

    public static SemesterCheckInListFragment newInstance() { return new SemesterCheckInListFragment(); }

    public void makeCheckInRequest() {

    }

    public RecyclerView.Adapter getAdapter() {

    }

    public void onEvent(SemesterEvent event) {
        Semester userSemesters = event.getSemester();
    }

    public void onEvent(CheckInListEvent event) {
        List<CheckIn> checkIns = event.getCheckIns();
    }

    public void onEvent(APIErrorEvent event) {
        mCheckInRefreshView.setRefreshing(false);
        mEmptyView.setRefreshing(false);
    }
}
