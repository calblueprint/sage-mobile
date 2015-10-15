package blueprint.com.sage.sign_up.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Spinner;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import blueprint.com.sage.sign_up.adapters.SignUpSchoolSpinnerAdapter;
import blueprint.com.sage.sign_up.adapters.SignUpTypeSpinnerAdapter;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/12/15.
 * Fragment where users can choose their school/volunteer type
 */
public class SignUpSchoolFragment extends SignInAbstractFragment {

    @Bind(R.id.sign_up_school) Spinner mSchoolSpinner;
    @Bind(R.id.sign_up_volunteer_type) Spinner mVolunteerTypeSpinner;

    public static SignUpSchoolFragment newInstance() { return new SignUpSchoolFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_sign_up_school, parent, false);
        ButterKnife.bind(this, view);
        initializeFields();
        return view;
    }

    private void initializeFields() {
        ArrayAdapter<School> schoolAdapter =
                new SignUpSchoolSpinnerAdapter(getParentActivity(),
                                               R.layout.sign_in_spinner_item,
                                               getParentActivity().getSchools());
        mSchoolSpinner.setAdapter(schoolAdapter);
        int selectedSchool = getParentActivity().getUser().getSchoolPosition();
        if (selectedSchool > -1) {
            mSchoolSpinner.setSelection(selectedSchool);
        }

        ArrayAdapter<String> typeAdapter =
                new SignUpTypeSpinnerAdapter(getParentActivity(),
                                             R.layout.sign_in_spinner_item,
                                             getResources().getStringArray(R.array.sign_up_volunteer_types));
        mVolunteerTypeSpinner.setAdapter(typeAdapter);
        int selectedType = getParentActivity().getUser().getTypePosition();
        if (selectedType > -1) {
            mVolunteerTypeSpinner.setSelection(selectedType);
        }
    }

    public boolean hasValidFields() {
        return true;
    }

    public void continueToNextPage() {

    }
}
