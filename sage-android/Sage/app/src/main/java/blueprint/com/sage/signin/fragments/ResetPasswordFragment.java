package blueprint.com.sage.signIn.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.Toast;

import java.util.HashMap;

import blueprint.com.sage.R;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.sessions.ResetPasswordEvent;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.shared.validators.FormValidator;
import blueprint.com.sage.shared.views.SimpleLoadingLayout;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 4/9/16.
 */
public class ResetPasswordFragment extends Fragment implements FormValidation {

    @Bind(R.id.reset_password_email) EditText mResetPasswordEmail;
    @Bind(R.id.reset_password_button) SimpleLoadingLayout mResetPasswordButton;

    private FormValidator mFormValidator;

    public static ResetPasswordFragment newInstance() { return new ResetPasswordFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mFormValidator = FormValidator.newInstance(getActivity());
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup parent, Bundle savedInstanceState) {
        super.onCreateView(inflater, parent, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_reset_password, parent, false);
        ButterKnife.bind(this, view);
        return view;
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

    @OnClick(R.id.reset_password_button)
    public void onResetClick() {
        validateAndSubmitRequest();
    }

    public void validateAndSubmitRequest() {
        if (!isValid())
            return;

        HashMap<String, String> params = new HashMap<>();
        params.put("email", mResetPasswordEmail.getText().toString());

        Requests.Sessions.with(getActivity()).makeResetPasswordRequest(params);
        mResetPasswordButton.startSpinning();
    }

    private boolean isValid() {
        return mFormValidator.hasNonBlankField(mResetPasswordEmail, getString(R.string.cannot_be_blank)) &&
                mFormValidator.hasValidEmail(mResetPasswordEmail);
    }

    public void onEvent(ResetPasswordEvent event) {
        Toast.makeText(getActivity(), event.getApiSuccess().getMessage(), Toast.LENGTH_SHORT);
        FragUtils.popBackStack(this);
    }

    public void onEvent(APIErrorEvent event) {
        mResetPasswordButton.stopSpinning();
    }
}
