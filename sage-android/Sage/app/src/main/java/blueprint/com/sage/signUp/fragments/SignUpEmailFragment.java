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
 * Sign Up email fragment
 */
public class SignUpEmailFragment extends SignUpAbstractFragment {

    @Bind(R.id.sign_up_email) EditText mEmail;
    @Bind(R.id.sign_up_password) EditText mPassword;
    @Bind(R.id.sign_up_password_confirm) EditText mConfirmation;

    private FormValidator mValidator;

    public static SignUpEmailFragment newInstance() { return new SignUpEmailFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mValidator = FormValidator.newInstance(getActivity());
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
        String email = mSignUpInterface.getUser().getEmail();
        if (email != null && !email.isEmpty())
            mEmail.setText(email);

        String password = mSignUpInterface.getUser().getPassword();
        if (password != null && !password.isEmpty())
            mPassword.setText(password);

        String passwordConfirm = mSignUpInterface.getUser().getPasswordConfirmation();
        if (passwordConfirm != null && !passwordConfirm.isEmpty())
            mConfirmation.setText(passwordConfirm);
    }

    public boolean hasValidFields() {
        return mValidator.hasValidEmail(mEmail) &
                (mValidator.hasNonBlankField(mPassword, "Password") &
                        mValidator.hasNonBlankField(mConfirmation, "Password Confirmation")) &&
                mValidator.hasMatchingPassword(mPassword, mConfirmation);
    }

    public void setUserFields() {
        User user = mSignUpInterface.getUser();
        user.setEmail(mEmail.getText().toString());
        user.setPassword(mPassword.getText().toString());
        user.setPasswordConfirmation(mConfirmation.getText().toString());
    }
}
