package blueprint.com.sage.notifications;

import android.app.IntentService;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.util.Log;

import com.google.android.gms.gcm.GoogleCloudMessaging;
import com.google.android.gms.iid.InstanceID;

import blueprint.com.sage.R;

/**
 * Created by kelseylam on 4/11/16.
 */
public class RegistrationIntentService extends IntentService {

    private static final String TAG = "RegIntentService";
    public static final String SENT_TOKEN_TO_SERVER = "sentTokenToServer";

    public RegistrationIntentService() {
        super(TAG);
    }

    @Override
    protected void onHandleIntent(Intent intent) {
        SharedPreferences sharedPreferences = getSharedPreferences(getString(R.string.preferences), MODE_PRIVATE);
        try {
            InstanceID instanceID = InstanceID.getInstance(this);
            String token = instanceID.getToken(getString(R.string.gcm_defaultSenderId), GoogleCloudMessaging.INSTANCE_ID_SCOPE, null);
            sendRegistrationToServer(token);
        } catch (Exception e) {
            Log.d(TAG, "Failed to complete token refresh", e);
            sharedPreferences.edit().putBoolean(SENT_TOKEN_TO_SERVER, false).apply();
        }
    }

    private void sendRegistrationToServer(String token) {
        Bundle bundle = new Bundle();
        bundle.putString(getApplicationContext().getString(R.string.registration_token), token);

        Intent intent = new Intent(getApplicationContext().getString(R.string.registration_complete));
        intent.putExtras(bundle);

        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
    }

}
