package blueprint.com.sage.signin;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;

import com.android.volley.RequestQueue;
import com.android.volley.Response;

import java.util.HashMap;

import blueprint.com.sage.R;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.network.SignInRequest;
import blueprint.com.sage.utility.network.NetworkManager;
import butterknife.Bind;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by kelseylam on 10/11/15.
 */
public class SignInFragment extends Fragment {

    @Bind(R.id.sign_in_email) EditText mUserField;
    @Bind(R.id.sign_in_password) EditText mPasswordField;
    @Bind(R.id.login_button) Button loginButton;


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

    @OnClick(R.id.login_button)
    public void pressLogin(Button loginButton) {
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
        if (error) {
            return;
        }
        HashMap<String, String> params = new HashMap<String, String>();
        params.put("email", email);
        params.put("password", password);
        SignInActivity activity = (SignInActivity) getActivity();
        NetworkManager networkManager = NetworkManager.getInstance(activity);
        RequestQueue requestQueue = networkManager.getRequestQueue();
        SignInRequest loginRequest = new SignInRequest(activity, params, new Response.Listener<Session>() {
            @Override
            public void onResponse(Session session) {

            }
        }, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError apiError) {

            }
        });
        requestQueue.add(loginRequest);
    }



//    private void something() {
//        mTextView.setError("asdfasdasdf");
//    }
}
