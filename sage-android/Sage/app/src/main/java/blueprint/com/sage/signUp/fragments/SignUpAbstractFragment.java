package blueprint.com.sage.signUp.fragments;

import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;

import blueprint.com.sage.R;
import blueprint.com.sage.signUp.SignUpActivity;
import butterknife.OnClick;

/**
 * Created by charlesx on 10/13/15.
 * Abstract class inherited by Sign Up fragments
 */
public abstract class SignUpAbstractFragment extends Fragment {
    public SignUpActivity getParentActivity() {
        return (SignUpActivity) getActivity();
    }

    @Nullable
    @OnClick(R.id.sign_up_continue)
    public void submitForm() {
        if (hasValidFields()) {
            setUserFields();
            continueToNextPage();
        }
    }

    @Nullable
    @OnClick(R.id.sign_up_finish)
    public void createUser() {
        setUserFields();
        getParentActivity().makeUserRequest();
    }

    public abstract void setUserFields();
    public abstract boolean hasValidFields();

    public void continueToNextPage() {
        SignUpPagerFragment fragment = (SignUpPagerFragment) getParentFragment();
        fragment.goToNextPage();
    }
}
