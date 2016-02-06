package blueprint.com.sage.landing;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.crashlytics.android.Crashlytics;

import blueprint.com.sage.R;
import blueprint.com.sage.events.SessionEvent;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.activities.AbstractActivity;
import blueprint.com.sage.signIn.SignInActivity;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
import de.greenrobot.event.EventBus;
import io.fabric.sdk.android.Fabric;

/**
 * Created by kelseylam on 2/3/16.
 */
public class LandingActivity extends AbstractActivity {

    private SharedPreferences mPreferences;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_landing);

        if (!NetworkUtils.isConnectedToInternet(this)) {
            Toast.makeText(this, "You're not connected to the internet!", Toast.LENGTH_SHORT).show();
            finish();
            return;
        }

        if (!NetworkUtils.isVerifiedUser(this, getSharedPreferences())) {
            FragUtils.startActivity(this, SignInActivity.class);
            return;
        }

        Requests.Users.with(this).makeStateRequest(getUser());
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

    public void onEvent(SessionEvent event) {
        try {
            NetworkUtils.loginUser(this, event.getSession());
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
    }
}
