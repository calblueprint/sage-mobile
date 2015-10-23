package blueprint.com.sage.sign_up.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

import java.util.regex.Pattern;

import blueprint.com.sage.R;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/12/15.
 * Sign Up email fragment
 */
public class SignUpEmailFragment extends SignUpAbstractFragment {

    @Bind(R.id.sign_up_email) EditText mEmail;
    @Bind(R.id.sign_up_password) EditText mPassword;
    @Bind(R.id.sign_up_password_confirm) EditText mConfirmation;

    public final Pattern VALID_EMAIL_ADDRESS_REGEX =
            Pattern.compile("^[A-Z0-9._%+-]+@berkeley\\.edu$", Pattern.CASE_INSENSITIVE);

    public static SignUpEmailFragment newInstance() { return new SignUpEmailFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_sign_up_email, parent, false);
        ButterKnife.bind(this, view);
        initializeViews();
        return view;
    }

    private void initializeViews() {
        String email = getParentActivity().getUser().getEmail();
        if (email != null && !email.isEmpty())
            mEmail.setText(email);

        String password = getParentActivity().getUser().getPassword();
        if (password != null && !password.isEmpty())
            mPassword.setText(password);

        String passwordConfirm = getParentActivity().getUser().getConfirmPassword();
        if (passwordConfirm != null && !passwordConfirm.isEmpty())
            mConfirmation.setText(passwordConfirm);
    }

    public boolean hasValidFields() {
        boolean isValid = true;

        if (!hasValidEmail()) {
            mEmail.setError(getString(R.string.sign_up_email_error));
            isValid = false;
        }

        if (!hasNonBlankPassword()) {
            mPassword.setError(getString(R.string.sign_up_password_blank_error));
            isValid = false;
        } else if (!hasMatchingPassword()) {
            mPassword.setError(getString(R.string.sign_up_password_nonmatch_error));
            isValid = false;
        }

        return isValid;
    }

    private boolean hasValidEmail() {
        return VALID_EMAIL_ADDRESS_REGEX.matcher(mPassword.getText().toString()).find();
    }

    private boolean hasNonBlankPassword() {
        return !mPassword.getText().toString().isEmpty() &&
               !mConfirmation.getText().toString().isEmpty();
    }

    private boolean hasMatchingPassword() {
        return mPassword.getText().toString().equals(mConfirmation.getText().toString());
    }
}
