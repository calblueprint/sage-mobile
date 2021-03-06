package blueprint.com.sage.signUp.fragments;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.View;

import blueprint.com.sage.R;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.shared.interfaces.SignUpInterface;
import blueprint.com.sage.shared.views.SimpleLoadingLayout;
import butterknife.Bind;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 10/13/15.
 * Abstract class inherited by Sign Up fragments
 */
public abstract class SignUpAbstractFragment extends Fragment {

    @Nullable @Bind(R.id.sign_up_finish) SimpleLoadingLayout mLayout;
    @Bind(R.id.white_dots_container) View mWhiteDotsLayout;

    public SignUpInterface mSignUpInterface;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mSignUpInterface = (SignUpInterface) getActivity();
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        moveDotsLayout();
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

    private void moveDotsLayout() {
        int resourceId = getResources().getIdentifier("navigation_bar_height", "dimen", "android");
        if (resourceId <= 0) {
            return;
        }

        mWhiteDotsLayout.setTranslationY(-getResources().getDimensionPixelSize(resourceId));
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
        mSignUpInterface.makeUserRequest();
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
