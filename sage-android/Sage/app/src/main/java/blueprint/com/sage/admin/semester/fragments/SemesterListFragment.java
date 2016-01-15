package blueprint.com.sage.admin.semester.fragments;

import java.util.HashMap;

import blueprint.com.sage.admin.semester.adapters.SemesterListAdapter;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.adapters.models.AbstractSemesterListAdapter;
import blueprint.com.sage.shared.fragments.AbstractSemesterListFragment;

/**
 * Created by charlesx on 1/7/16.
 * Shows a list of semesters
 */
public class SemesterListFragment extends AbstractSemesterListFragment {

    public static SemesterListFragment newInstance() { return new SemesterListFragment(); }

    public AbstractSemesterListAdapter getAdapter() {
        return new SemesterListAdapter(getActivity(), mSemesters);
    }

    public void makeSemesterListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("sort[attr]", "created_at");
        queryParams.put("sort[order]", "desc");
        Requests.Semesters.with(getActivity()).makeListRequest(queryParams);
    }
}
