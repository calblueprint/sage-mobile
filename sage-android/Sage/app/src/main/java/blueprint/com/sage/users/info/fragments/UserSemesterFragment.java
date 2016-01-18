package blueprint.com.sage.users.info.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import java.util.HashMap;

import blueprint.com.sage.R;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 1/15/16.
 */
public class UserSemesterFragment extends Fragment {

    private User mUser;
    private Semester mSemester;

    public static UserSemesterFragment newInstance(User user, Semester semester) {
        UserSemesterFragment fragment = new UserSemesterFragment();
        fragment.setUser(user);
        fragment.setSemester(semester);
        return fragment;
    }

    public void setUser(User user) { mUser = user; }
    public void setSemester(Semester semester) { mSemester = semester; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        makeUserSemesterRequest();
    }

    private void makeUserSemesterRequest() {
        HashMap<String, String> queryRequests = new HashMap<>();
        queryRequests.put("user_id", String.valueOf(mUser.getId()));
        queryRequests.put("semester_id", String.valueOf(mSemester.getId()));
        Requests.UserSemesters.with(getActivity()).makeListRequest(queryRequests);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user_semester, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }
}
