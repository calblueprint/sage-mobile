package blueprint.com.sage.users.info.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
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
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_user_semester, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }
}
