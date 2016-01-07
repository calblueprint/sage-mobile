package blueprint.com.sage.semester.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 1/7/16.
 * Finish a semester
 */
public class FinishSemesterFragment extends Fragment {

    public static FinishSemesterFragment newInstance() { return new FinishSemesterFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_finish_semester, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }
}
