package blueprint.com.sage.notifications;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.util.Log;

import com.google.android.gms.gcm.GcmListenerService;

import blueprint.com.sage.main.MainActivity;

/**
 * Created by kelseylam on 3/30/16.
 */
public class NotificationService extends GcmListenerService {

    public static final int NOTIFICATION_ID = 1;
    private static final String TAG = "NotificationService";
    private NotificationManager mNotificationManager;

    @Override
    public void onMessageReceived(String from, Bundle data) {


        String message = data.getString("message");
        String type = data.getString("type");
        String object = data.getString("object");
        Log.d(TAG, "From: " + from);
        Log.d(TAG, "Message: " + message);
        sendNotification(message, type, object);

//        sendNotification(message);
    }

    private void sendNotification(String message, String type, String object) {
        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
                        .setContentTitle("Sage Notification")
                        .setStyle(new NotificationCompat.BigTextStyle())
                        .setContentText(message)
                        .setAutoCancel(true);

        Bundle intentBundle = new Bundle();
        intentBundle.putString("type", type);
        intentBundle.putString(type, object);

        Intent intent = new Intent(this, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK |
                Intent.FLAG_ACTIVITY_CLEAR_TOP |
                Intent.FLAG_ACTIVITY_SINGLE_TOP);

        intent.putExtras(intentBundle);

        PendingIntent contentIntent =
                PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        mBuilder.setContentIntent(contentIntent);

        mNotificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        mNotificationManager.notify(NOTIFICATION_ID, mBuilder.build());
    }
}
