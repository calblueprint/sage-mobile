package blueprint.com.sage.sign_up.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/12/15.
 */
public class SignUpNameFragment extends SignUpAbstractFragment {

    @Bind(R.id.sign_up_first_name) EditText mFirstName;
    @Bind(R.id.sign_up_last_name) EditText mLastName;

    public static SignUpNameFragment newInstance() { return new SignUpNameFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
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
        boolean isValid = true;

        if (!hasValidFirstName()) {
            mFirstName.setError(getString(R.string.cannot_be_blank,
                                getString(R.string.sign_up_first_name)));
            isValid = false;
        }

        if (!hasValidLastName()) {
            mLastName.setError(getString(R.string.cannot_be_blank,
                               getString(R.string.sign_up_last_name)));
            isValid = false;
        }

        User user = getParentActivity().getUser();
        user.setFirstName(mFirstName.getText().toString());
        user.setLastName(mLastName.getText().toString());

        return isValid;
    }

    private boolean hasValidFirstName() {
        return !mFirstName.getText().toString().isEmpty();
    }

    private boolean hasValidLastName() {
        return !mLastName.getText().toString().isEmpty();
    }
}
