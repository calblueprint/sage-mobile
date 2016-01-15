package blueprint.com.sage.users.info.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;

import java.util.HashMap;

import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.Requests;

/**
 * Created by charlesx on 1/15/16.
 */
public class SemesterCheckInListFragment extends Fragment {

    private Semester mSemester;

    public static SemesterCheckInListFragment newInstance(Semester semester) {
        SemesterCheckInListFragment fragment = new SemesterCheckInListFragment();
        fragment.setSemester(semester);
        return fragment;
    }

    public void setSemester(Semester semester) { mSemester = semester; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        makeCheckInListRequest();
    }

    private void makeCheckInListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        Requests.CheckIns.with(getActivity()).makeListRequest(queryParams);
    }
}
