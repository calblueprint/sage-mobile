package blueprint.com.sage.semester.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.events.semesters.SemesterEvent;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.Requests;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 1/7/16.
 * Shows an individual semester
 */
public class SemesterFragment extends Fragment {

    private Semester mSemester;

    public static SemesterFragment newInstance(Semester semester) {
        SemesterFragment fragment = new SemesterFragment();
        fragment.setSemester(semester);
        return fragment;
    }

    public void setSemester(Semester semester) { mSemester = semester; }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Requests.Semesters.with(getActivity()).makeShowRequest(mSemester);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_semester, parent, false);
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

    private void initializeSemester() {

    }

    public void onEvent(SemesterEvent event) {
        mSemester = event.getSemester();
        initializeSemester();
    }
}
