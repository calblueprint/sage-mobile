package blueprint.com.sage.signin;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.support.v4.app.FragmentTransaction;

import blueprint.com.sage.R;

/**
 * Created by kelseylam on 10/11/15.
 */
public class SignInActivity extends FragmentActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_in);
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        transaction.replace(R.id.sign_in_container, SignInFragment.newInstance()).commit();
    }
}
