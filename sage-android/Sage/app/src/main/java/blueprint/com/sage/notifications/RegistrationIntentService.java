package blueprint.com.sage.notifications;

import android.app.IntentService;
import android.content.Intent;
import android.content.SharedPreferences;
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
//    private Activity mActivity;

//    public static RegistrationIntentService newInstance(Activity activity) {
//        RegistrationIntentService service = new RegistrationIntentService();
//        service.setActivity(activity);
//        return service;
//    }

    public RegistrationIntentService() {
        super(TAG);
    }

//    public void setActivity(Activity activity) {
//        mActivity = activity;
//    }

    @Override
    protected void onHandleIntent(Intent intent) {
        SharedPreferences sharedPreferences = getSharedPreferences(getString(R.string.preferences), MODE_PRIVATE);

//        Bundle extras = intent.getExtras();
//        GoogleCloudMessaging gcm = GoogleCloudMessaging.getInstance(this);
//
//        String messageType = gcm.getMessageType(intent);
//
//        if (!extras.isEmpty()) {
//            if (GoogleCloudMessaging.MESSAGE_TYPE_MESSAGE.equals(messageType)) {
//                String message = extras.getString("message");
//                String type = extras.getString("type");
//                String object = extras.getString("object");
//                sendNotification(message, type, object);
//            }
//        }

        try {
            InstanceID instanceID = InstanceID.getInstance(this);
            String token = instanceID.getToken(getString(R.string.gcm_defaultSenderId), GoogleCloudMessaging.INSTANCE_ID_SCOPE, null);

            Log.i(TAG, "GCM Registration Token: " + token);

            sendRegistrationToServer(token);

            sharedPreferences.edit().putBoolean(getString(R.string.sent_token_to_server), true).apply();
        } catch (Exception e) {
            Log.d(TAG, "Failed to complete token refresh", e);
            sharedPreferences.edit().putBoolean(SENT_TOKEN_TO_SERVER, false).apply();
        }
    }

    private void sendRegistrationToServer(String token) {
        Log.i("wow", token);
//        Context context = getApplicationContext();
//        Requests.Users.with(context).makeRegisterRequest();
    }
}
