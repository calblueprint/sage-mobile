package blueprint.com.sage.signIn;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import java.util.HashMap;

import blueprint.com.sage.R;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.signUp.SignUpActivity;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by kelseylam on 10/11/15.
 */
public class SignInFragment extends Fragment {

    @Bind(R.id.sign_in_email) EditText mUserField;
    @Bind(R.id.sign_in_password) EditText mPasswordField;
    @Bind(R.id.sign_in_button) Button mLoginButton;
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
}
