package blueprint.com.sage.signIn.fragments;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.util.HashMap;

import blueprint.com.sage.R;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.sessions.SignInEvent;
import blueprint.com.sage.events.users.RegisterUserEvent;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.notifications.RegistrationIntentService;
import blueprint.com.sage.shared.FormValidation;
import blueprint.com.sage.shared.validators.FormValidator;
import blueprint.com.sage.shared.views.SimpleLoadingLayout;
import blueprint.com.sage.signUp.SignUpActivity;
import blueprint.com.sage.utility.RegistrationUtils;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 10/11/15.
 */
public class SignInFragment extends Fragment implements FormValidation {

    @Bind(R.id.sign_in_email) EditText mUserField;
    @Bind(R.id.sign_in_password) EditText mPasswordField;
    @Bind(R.id.sign_in_button) SimpleLoadingLayout mLoginButton;
    @Bind(R.id.sign_in_sign_up) TextView mSignUpTextView;

    private FormValidator mFormValidator;

    private User mUser;
    private BroadcastReceiver mBroadcastReceiver;
    private String mRegistrationId;

    public static SignInFragment newInstance() { return new SignInFragment(); }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mFormValidator = FormValidator.newInstance(getActivity());
        mBroadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                makeRegistrationRequest(intent);
            }
        };
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        View view = inflater.inflate(R.layout.fragment_sign_in, container, false);
        ButterKnife.bind(this, view);
        return view;
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onResume() {
        super.onResume();
        RegistrationUtils.registerReceivers(getActivity(), mBroadcastReceiver);
    }

    @Override
    public void onPause() {
        super.onPause();
        RegistrationUtils.unregisterReceivers(getActivity(), mBroadcastReceiver);
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    @OnClick(R.id.sign_in_button)
    public void validateAndSubmitRequest() {
        if (!isValid()) {
            return;
        }

        String email = mUserField.getText().toString();
        String password = mPasswordField.getText().toString();

        mLoginButton.startSpinning();
        HashMap<String, String> params = new HashMap<>();
        params.put("email", email);
        params.put("password", password);
        Requests.Sessions.with(getActivity()).makeSignInRequest(params);
    }

    private boolean isValid() {
        return (mFormValidator.hasValidEmail(mUserField) &&
                mFormValidator.hasNonBlankField(mUserField, getString(R.string.sign_in_email))) &
                mFormValidator.hasNonBlankField(mPasswordField, getString(R.string.sign_in_password));
    }

    private void makeRegistrationRequest(Intent intent) {
        Bundle bundle = intent.getExtras();
        mRegistrationId = bundle.getString(getString(R.string.registration_token));

        User user = mUser;
        if (user != null) {
            user.setDeviceType(RegistrationUtils.DEVICE_TYPE);
            user.setDeviceId(mRegistrationId);
            Requests.Users.with(getActivity()).makeRegistrationRequest(user);
        }
    }

    @OnClick(R.id.sign_in_sign_up)
    public void onSignUpPressed(TextView textView) {
        Intent intent = new Intent(getActivity(), SignUpActivity.class);
        startActivity(intent);
    }

    @OnClick(R.id.sign_in_reset_password)
    public void onResetPasswordPressed() {
        FragUtils.replaceBackStack(R.id.sign_in_container, ResetPasswordFragment.newInstance(), getActivity());
    }

    public void onEvent(SignInEvent event) {
        try {
            mUser = event.getSession().getUser();
            NetworkUtils.setSession(getActivity(), event.getSession());
            Intent intent = new Intent(getActivity(), RegistrationIntentService.class);
            getActivity().startService(intent);
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
    }

    public void onEvent(RegisterUserEvent event) {
        try {
            NetworkUtils.getSharedPreferences(getActivity())
                    .edit()
                    .putString(getString(R.string.registration_token), mRegistrationId)
                    .putInt(getString(R.string.app_version), RegistrationUtils.getAppVersion(getActivity()))
                    .apply();
            NetworkUtils.loginUser(getActivity(), event.getSession());
        } catch(Exception e) {
            Log.e(getClass().toString(), e.toString());
            Toast.makeText(getActivity(), "Something went wrong, try again!", Toast.LENGTH_SHORT).show();
        }
    }

    public void onEvent(APIErrorEvent event) {
        mLoginButton.stopSpinning();
    }
}
