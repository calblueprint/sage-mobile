package blueprint.com.sage.sign_up.fragments;

import android.support.v4.app.Fragment;

import blueprint.com.sage.R;
import blueprint.com.sage.sign_up.SignUpActivity;
import butterknife.OnClick;

/**
 * Created by charlesx on 10/13/15.
 * Abstract class inherited by Sign Up fragments
 */
public abstract class SignUpAbstractFragment extends Fragment {
    public SignUpActivity getParentActivity() {
        return (SignUpActivity) getActivity();
    }

    @OnClick(R.id.sign_up_continue)
    public void submitForm() {
        if (hasValidFields()) {
            continueToNextPage();
        }
    }

    public abstract boolean hasValidFields();

    public void continueToNextPage() {
        SignUpPagerFragment fragment = (SignUpPagerFragment) getParentFragment();
        fragment.goToNextPage();
    };
}
