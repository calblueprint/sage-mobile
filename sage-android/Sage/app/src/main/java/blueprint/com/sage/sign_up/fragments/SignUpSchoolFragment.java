package blueprint.com.sage.sign_up.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Spinner;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.sign_up.adapters.SignUpSchoolSpinnerAdapter;
import blueprint.com.sage.sign_up.adapters.SignUpTypeSpinnerAdapter;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/12/15.
 * Fragment where users can choose their school/volunteer type
 */
public class SignUpSchoolFragment extends SignUpAbstractFragment {

    @Bind(R.id.sign_up_school) Spinner mSchoolSpinner;
    @Bind(R.id.sign_up_volunteer_type) Spinner mVolunteerTypeSpinner;

    private SignUpSchoolSpinnerAdapter mSchoolAdapter;
    private SignUpTypeSpinnerAdapter mTypeAdapter;

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
        mSchoolAdapter =
                new SignUpSchoolSpinnerAdapter(getParentActivity(),
                                               R.layout.sign_in_spinner_item,
                                               R.id.sign_up_spinner_item_text,
                                               getParentActivity().getSchools());
        mSchoolSpinner.setAdapter(mSchoolAdapter);
        int selectedSchool = getParentActivity().getUser().getSchoolPosition();
        if (selectedSchool > -1) {
            mSchoolSpinner.setSelection(selectedSchool);
        }

        mTypeAdapter =
                new SignUpTypeSpinnerAdapter(getParentActivity(),
                                             R.layout.sign_in_spinner_item,
                                             R.id.sign_up_spinner_item_text,
                                             getResources().getStringArray(R.array.sign_up_volunteer_types));
        mVolunteerTypeSpinner.setAdapter(mTypeAdapter);
        int selectedType = getParentActivity().getUser().getTypePosition();
        if (selectedType > -1) {
            mVolunteerTypeSpinner.setSelection(selectedType);
        }
    }

    public boolean hasValidFields() {

        User user = getParentActivity().getUser();
        user.setSchoolId(((School) mSchoolSpinner.getSelectedItem()).getId());
        user.setSchoolPosition(mSchoolSpinner.getSelectedItemPosition());

        user.setVolunteerType((String) mSchoolSpinner.getSelectedItem());
        user.setTypePosition(mSchoolSpinner.getSelectedItemPosition());

        return true;
    }
}
