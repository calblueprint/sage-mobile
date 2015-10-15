package blueprint.com.sage.sign_up.fragments;

import android.support.v4.app.Fragment;

import blueprint.com.sage.sign_up.SignUpActivity;

/**
 * Created by charlesx on 10/13/15.
 * Abstract class inherited by Sign Up fragments
 */
public abstract class SignUpAbstractFragment extends Fragment {
    public SignUpActivity getParentActivity() {
        return (SignUpActivity) getActivity();
    }

    public void submitForm() {
        if (hasValidFields()) {
            continueToNextPage();
        }
    }

    public abstract boolean hasValidFields();
    public abstract void continueToNextPage();
}
