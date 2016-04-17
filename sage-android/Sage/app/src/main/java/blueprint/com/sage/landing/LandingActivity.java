package blueprint.com.sage.landing;

import android.content.BroadcastReceiver;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;
import android.widget.Toast;

import com.crashlytics.android.Crashlytics;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;
import com.google.android.gms.gcm.GoogleCloudMessaging;

import org.json.JSONObject;

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
    private BroadcastReceiver mRegistrationBroadcastReceiver;
    private boolean mIsReceiverRegistered;
    private String mRegistrationId;

    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private static final String TAG = "LandingActivity";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_landing);

        mPreferences = getSharedPreferences();

        if (!NetworkUtils.isConnectedToInternet(this)) {
            Toast.makeText(this, "You're not connected to the internet!", Toast.LENGTH_SHORT).show();
            finish();
            return;
        }

        if (!NetworkUtils.isVerifiedUser(this, getSharedPreferences())) {
            FragUtils.startActivity(this, SignInActivity.class);
            return;
        }

        mRegistrationId = mPreferences.getString("registration_id", "none");

        if (getRegistrationId().isEmpty()) {
            registerInBackground();
        }

        Requests.Users.with(this).makeStateRequest(getUser());

        // Register Broadcast Receiver
//        mRegistrationBroadcastReceiver = new BroadcastReceiver() {
//            @Override
//            public void onReceive(Context context, Intent intent) {
////                boolean sentToken = mPreferences
////                        .getBoolean(getString(R.string.sent_token_to_server), false);
////                if (sentToken) {
////                    mInformationTextView.setText(getString(R.string.gcm_send_message));
////                } else {
////                    mInformationTextView.setText(getString(R.string.token_error_message));
////                }
//            }
//        };
//        registerReceiver();
//
//        if (checkPlayServices()) {
//            // Start IntentService to register this application with GCM.
//            Intent intent = new Intent(this, RegistrationIntentService.class);
//            startService(intent);
//        }
    }

    public void registerInBackground() {
        new AsyncTask<String, String, String>() {
            @Override
            protected String doInBackground(String... params) {
                String msg = "";
                JSONObject user = new JSONObject();
                JSONObject objParams = new JSONObject();
                try {
                    if (mGoogleCloudMessaging == null) mGoogleCloudMessaging = GoogleCloudMessaging.getInstance(LandingActivity.this);
                    objParams.put("registration_id", mGoogleCloudMessaging.register(SENDER_ID));
                    objParams.put("device_type", 0);
                    user.put("user", objParams);
                } catch (Exception ex) {
                    msg = "Error :" + ex.getMessage();
                }
                return msg;
            }

            @Override
            protected void onPostExecute(String msg) { Log.i("ERROR", msg + "\n"); }
        }.execute(null, null, null);
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

    @Override
    protected void onResume() {
        super.onResume();
        registerReceiver();
    }

    @Override
    protected void onPause() {
        LocalBroadcastManager.getInstance(this).unregisterReceiver(mRegistrationBroadcastReceiver);
        mIsReceiverRegistered = false;
        super.onPause();
    }

    /**
     * Gets the current registration ID for application on GCM service.
     * If result is empty, the app needs to register.
     *
     * @return registration ID, or empty string if there is no existing
     *         registration ID.
     */
    private String getRegistrationId() {
        if (mRegistrationId.equals("none")) {
            Log.i(TAG, "Registration not found.");
            return "";
        }

        // Check if app was updated; if so, it must clear the registration ID
        // since the existing registration ID is not guaranteed to work with
        // the new app version.
//        int currentVersion = Utility.getAppVersion(this);
//        if (mAppVersion != currentVersion) {
//            Log.i(TAG, "App version changed.");
//            mPreferences.edit().putInt("app_version", currentVersion).apply();
//            return "";
//        }
        return mRegistrationId;
    }

    private void registerReceiver(){

        if(!mIsReceiverRegistered) {
            LocalBroadcastManager.getInstance(this).registerReceiver(mRegistrationBroadcastReceiver,
                    new IntentFilter(getString(R.string.registration_complete)));
            mIsReceiverRegistered = true;
        }
    }

    private boolean checkPlayServices() {
        GoogleApiAvailability apiAvailability = GoogleApiAvailability.getInstance();
        int resultCode = apiAvailability.isGooglePlayServicesAvailable(this);
        if (resultCode != ConnectionResult.SUCCESS) {
            if (apiAvailability.isUserResolvableError(resultCode)) {
                apiAvailability.getErrorDialog(this, resultCode, PLAY_SERVICES_RESOLUTION_REQUEST)
                        .show();
            } else {
                Log.i(TAG, "This device is not supported.");
                finish();
            }
            return false;
        }
        return true;
    }

    public void onEvent(SessionEvent event) {
        try {
            NetworkUtils.loginUser(this, event.getSession());
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
    }
}
