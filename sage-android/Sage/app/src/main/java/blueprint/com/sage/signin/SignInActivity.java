package blueprint.com.sage.signIn;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

import blueprint.com.sage.R;
import blueprint.com.sage.signIn.fragments.SignInFragment;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by kelseylam on 10/11/15.
 * Activity for signing in.
 */
public class SignInActivity extends FragmentActivity {
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_in);
        FragUtils.replace(R.id.sign_in_container, SignInFragment.newInstance(), this);
    }
}
