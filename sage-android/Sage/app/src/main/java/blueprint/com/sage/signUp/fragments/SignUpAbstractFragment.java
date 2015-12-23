package blueprint.com.sage.signUp.fragments;

import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;

import blueprint.com.sage.R;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.shared.views.SimpleLoadingLayout;
import blueprint.com.sage.signUp.SignUpActivity;
import butterknife.Bind;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 10/13/15.
 * Abstract class inherited by Sign Up fragments
 */
public abstract class SignUpAbstractFragment extends Fragment {

    @Nullable @Bind(R.id.sign_up_finish) SimpleLoadingLayout mLayout;

    public SignUpActivity getParentActivity() {
        return (SignUpActivity) getActivity();
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
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
        if (mLayout != null)
            mLayout.startSpinning();
        setUserFields();
        getParentActivity().makeUserRequest();
    }

    public void onEvent(APIError error) {
        if (mLayout != null)
            mLayout.stopSpinning();
    }

    public abstract void setUserFields();
    public abstract boolean hasValidFields();

    public void continueToNextPage() {
        SignUpPagerFragment fragment = (SignUpPagerFragment) getParentFragment();
        fragment.goToNextPage();
    }
}
