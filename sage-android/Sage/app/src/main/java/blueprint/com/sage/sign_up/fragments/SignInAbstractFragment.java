package blueprint.com.sage.sign_up.fragments;

import android.support.v4.app.Fragment;

import blueprint.com.sage.sign_up.SignUpActivity;

/**
 * Created by charlesx on 10/13/15.
 * Abstract class inherited by Sign Up fragments
 */
public abstract class SignInAbstractFragment extends Fragment {
    public SignUpActivity getParentActivity() {
        return (SignUpActivity) getActivity();
    }
}
