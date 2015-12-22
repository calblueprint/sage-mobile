package blueprint.com.sage.signIn;

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
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.views.SimpleLoadingLayout;
import blueprint.com.sage.signUp.SignUpActivity;
import blueprint.com.sage.utility.network.NetworkUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 10/11/15.
 */
public class SignInFragment extends Fragment {

    @Bind(R.id.sign_in_email) EditText mUserField;
    @Bind(R.id.sign_in_password) EditText mPasswordField;
    @Bind(R.id.sign_in_button) SimpleLoadingLayout mLoginButton;
    @Bind(R.id.sign_in_sign_up) TextView mSignUpTextView;

    public static SignInFragment newInstance() {
        return new SignInFragment();
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
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
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    @OnClick(R.id.sign_in_button)
    public void onLoginPressed() {
        boolean error = false;
        String email = mUserField.getText().toString();
        String password = mPasswordField.getText().toString();

        if (email.isEmpty()) {
            mUserField.setError("Enter an email.");
            error = true;
        }

        if (password.isEmpty()) {
            mPasswordField.setError("Enter your password.");
            error = true;
        }

        if (error)
            return;

        mLoginButton.startSpinning();
        HashMap<String, String> params = new HashMap<>();
        params.put("email", email);
        params.put("password", password);
        Requests.SignIn.with(getActivity()).makeSignInRequest(params);
    }

    @OnClick(R.id.sign_in_sign_up)
    public void onSignUpPressed(TextView textView) {
        Intent intent = new Intent(getActivity(), SignUpActivity.class);
        startActivity(intent);
    }

    public void onEvent(SignInEvent event) {
        try {
            mLoginButton.stopSpinning();
            NetworkUtils.loginUser(event.getSession(), getActivity());
        } catch(Exception e) {
            Log.e(getClass().toString(), e.toString());
            Toast.makeText(getActivity(), "Something went wrong, try again!", Toast.LENGTH_SHORT).show();
        }
    }

    public void onEvent(APIErrorEvent event) {
        mLoginButton.stopSpinning();
    }
}
