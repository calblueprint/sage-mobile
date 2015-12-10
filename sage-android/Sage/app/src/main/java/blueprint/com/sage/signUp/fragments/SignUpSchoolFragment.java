package blueprint.com.sage.signUp.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.Spinner;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.adapters.SchoolSpinnerAdapter;
import blueprint.com.sage.shared.adapters.TypeSpinnerAdapter;
import blueprint.com.sage.shared.validators.FormValidator;
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

    private SchoolSpinnerAdapter mSchoolAdapter;
    private TypeSpinnerAdapter mTypeAdapter;

    private FormValidator mValidator;

    public static SignUpSchoolFragment newInstance() { return new SignUpSchoolFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mValidator = FormValidator.newInstance(getActivity());
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
                new SchoolSpinnerAdapter(getParentActivity(),
                                               getParentActivity().getSchools(),
                                               R.layout.sign_in_spinner_item,
                                               R.layout.sign_in_spinner_drop_item);
        mSchoolSpinner.setAdapter(mSchoolAdapter);
        int selectedSchool = getParentActivity().getUser().getSchoolPosition();
        if (selectedSchool > -1) {
            mSchoolSpinner.setSelection(selectedSchool);
        }

        mTypeAdapter =
                new TypeSpinnerAdapter(getParentActivity(),
                                             getResources().getStringArray(R.array.volunteer_types),
                                             R.layout.sign_in_spinner_item,
                                             R.layout.sign_in_spinner_drop_item);
        mVolunteerTypeSpinner.setAdapter(mTypeAdapter);
        int selectedType = getParentActivity().getUser().getTypePosition();
        if (selectedType > -1) {
            mVolunteerTypeSpinner.setSelection(selectedType);
        }
    }

    public boolean hasValidFields() {
        return mValidator.mustBePicked(mSchoolSpinner, "School", mLayout);
    }

    public void setUserFields() {
        User user = getParentActivity().getUser();
        user.setSchoolId(((School) mSchoolSpinner.getSelectedItem()).getId());

        user.setSchoolPosition(mSchoolSpinner.getSelectedItemPosition());
        user.setVolunteerTypeInt(mVolunteerTypeSpinner.getSelectedItemPosition());
    }
}
