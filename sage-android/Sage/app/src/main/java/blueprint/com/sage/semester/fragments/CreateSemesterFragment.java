package blueprint.com.sage.semester.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import blueprint.com.sage.R;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 1/6/16.
 */
public class CreateSemesterFragment extends Fragment {

    public static CreateSemesterFragment newInstance() { return new CreateSemesterFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_create_semester, parent, false);
        ButterKnife.bind(this, view);
        return view;
    }
}
