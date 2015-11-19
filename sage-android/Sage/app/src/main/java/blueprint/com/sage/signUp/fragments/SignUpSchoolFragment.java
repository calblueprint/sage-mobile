package blueprint.com.sage.signUp.fragments;

import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.Spinner;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.signUp.adapters.SignUpSchoolSpinnerAdapter;
import blueprint.com.sage.signUp.adapters.SignUpTypeSpinnerAdapter;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/12/15.
 * Fragment where users can choose their school/volunteer type
 */
public class SignUpSchoolFragment extends SignUpAbstractFragment {

    @Bind(R.id.sign_up_school_layout) LinearLayout mLayout;
    @Bind(R.id.sign_up_school) Spinner mSchoolSpinner;
    @Bind(R.id.sign_up_volunteer_type) Spinner mVolunteerTypeSpinner;

    private SignUpSchoolSpinnerAdapter mSchoolAdapter;
    private SignUpTypeSpinnerAdapter mTypeAdapter;

    public static SignUpSchoolFragment newInstance() { return new SignUpSchoolFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) { super.onCreate(savedInstanceState); }

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
                                               getParentActivity().getSchools());
        mSchoolSpinner.setAdapter(mSchoolAdapter);
        int selectedSchool = getParentActivity().getUser().getSchoolPosition();
        if (selectedSchool > -1) {
            mSchoolSpinner.setSelection(selectedSchool);
        }

        mTypeAdapter =
                new SignUpTypeSpinnerAdapter(getParentActivity(),
                                             R.layout.sign_in_spinner_item,
                                             getResources().getStringArray(R.array.sign_up_volunteer_types));
        mVolunteerTypeSpinner.setAdapter(mTypeAdapter);
        int selectedType = getParentActivity().getUser().getTypePosition();
        if (selectedType > -1) {
            mVolunteerTypeSpinner.setSelection(selectedType);
        }
    }

    public boolean hasValidFields() {
        boolean isValid = true;

        String snackBarString = "";

        if (mSchoolSpinner.getSelectedItem() == null) {
            snackBarString += "School &";
            isValid = false;
        }

        if (mVolunteerTypeSpinner.getSelectedItem() == null) {
            snackBarString += "Volunteer Type";
            isValid = false;
        }

        if (!isValid) {
            snackBarString += "can't be blank!";
            Snackbar.make(mLayout, snackBarString, Snackbar.LENGTH_SHORT).show();
        }

        return isValid ;
    }

    public void setUserFields() {
        User user = getParentActivity().getUser();
        user.setSchoolId(((School) mSchoolSpinner.getSelectedItem()).getId());

        user.setSchoolPosition(mSchoolSpinner.getSelectedItemPosition());
        user.setVolunteerTypePosition(mVolunteerTypeSpinner.getSelectedItemPosition());
    }
}
