package blueprint.com.sage.signUp.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.validators.FormValidator;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/12/15.
 */
public class SignUpNameFragment extends SignUpAbstractFragment {

    @Bind(R.id.sign_up_first_name) EditText mFirstName;
    @Bind(R.id.sign_up_last_name) EditText mLastName;

    private FormValidator mValidator;

    public static SignUpNameFragment newInstance() { return new SignUpNameFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mValidator = FormValidator.newInstance(getParentActivity());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_sign_up_name, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    private void initializeViews() {
        String firstName = getParentActivity().getUser().getFirstName();
        if (firstName != null && !firstName.isEmpty()) {
            mFirstName.setText(firstName);
        }

        String lastName = getParentActivity().getUser().getLastName();
        if (lastName != null && !lastName.isEmpty()) {
            mLastName.setText(lastName);
        }
    }

    public boolean hasValidFields() {
        return mValidator.hasNonBlankField(mFirstName, "First Name") &
                mValidator.hasNonBlankField(mLastName, "Last Name");
    }

    public void setUserFields() {
        User user = getParentActivity().getUser();
        user.setFirstName(mFirstName.getText().toString());
        user.setLastName(mLastName.getText().toString());
    }
}
