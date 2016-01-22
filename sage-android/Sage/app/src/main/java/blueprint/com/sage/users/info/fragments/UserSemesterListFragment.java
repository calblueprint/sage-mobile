package blueprint.com.sage.users.info.fragments;

import java.util.HashMap;

import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.adapters.models.AbstractSemesterListAdapter;
import blueprint.com.sage.shared.fragments.AbstractSemesterListFragment;
import blueprint.com.sage.users.info.adapters.UserSemesterListAdapter;

/**
 * Created by charlesx on 1/15/16.
 */
public class UserSemesterListFragment extends AbstractSemesterListFragment {

    private User mUser;

    public static UserSemesterListFragment newInstance(User user) {
        UserSemesterListFragment fragment = new UserSemesterListFragment();
        fragment.setUser(user);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }

    public AbstractSemesterListAdapter getAdapter() {
        return new UserSemesterListAdapter(getActivity(), mSemesters, mUser);
    }

    public void makeSemesterListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("user_id", String.valueOf(mUser.getId()));
        queryParams.put("sort[attr]", "created_at");
        queryParams.put("sort[order]", "desc");
        Requests.Semesters.with(getActivity()).makeListRequest(queryParams);
    }
}
