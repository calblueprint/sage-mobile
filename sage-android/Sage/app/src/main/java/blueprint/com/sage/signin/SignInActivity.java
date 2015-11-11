package blueprint.com.sage.signIn;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;

import com.crashlytics.android.Crashlytics;

import blueprint.com.sage.R;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
import io.fabric.sdk.android.Fabric;

/**
 * Created by kelseylam on 10/11/15.
 * Activity for signing in.
 */
public class SignInActivity extends FragmentActivity {

    private SharedPreferences mPreferences;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_sign_in);

        mPreferences = getSharedPreferences(getString(R.string.preferences), MODE_PRIVATE);

        if (NetworkUtils.isVerifiedUser(this, mPreferences)) {
            try {
                NetworkUtils.loginUser(this);
            } catch(Exception e) {
                Log.e(getClass().toString(), e.toString());
            }
        } else {
            FragUtils.replace(R.id.sign_in_container, SignInFragment.newInstance(), this);
        }
    }
}
