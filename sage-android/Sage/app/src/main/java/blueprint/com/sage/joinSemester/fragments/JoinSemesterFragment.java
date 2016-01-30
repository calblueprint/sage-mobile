package blueprint.com.sage.joinSemester.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by charlesx on 1/30/16.
 */
public class JoinSemesterFragment extends Fragment {

    private BaseInterface mBaseInterface;

    public static JoinSemesterFragment newInstance() { return new JoinSemesterFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBaseInterface = (BaseInterface) getActivity();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_join_semester, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }

    @OnClick(R.id.join_semester_button)
    public void onJoinSemester() {
        Requests.Semesters.with(getActivity()).makeJoinR
    }
}
