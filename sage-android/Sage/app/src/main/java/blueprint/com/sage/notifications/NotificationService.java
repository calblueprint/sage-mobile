package blueprint.com.sage.notifications;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.ContextCompat;

import com.google.android.gms.gcm.GcmListenerService;

import blueprint.com.sage.R;
import blueprint.com.sage.main.MainActivity;
import blueprint.com.sage.utility.network.NetworkUtils;

/**
 * Created by kelseylam on 3/30/16.
 */
public class NotificationService extends GcmListenerService {

    public static final int NOTIFICATION_ID = 1;
    private NotificationManager mNotificationManager;

    @Override
    public void onMessageReceived(String from, Bundle data) {
        String message = data.getString("message");
        String type = data.getString("type");
        String object = data.getString("object");

        if (NetworkUtils.isVerifiedUser(getBaseContext())) {
            sendNotification(message, type, object);
        }
    }

    private void sendNotification(String message, String type, String object) {
        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
                        .setSmallIcon(R.drawable.notification)
                        .setColor(ContextCompat.getColor(getBaseContext(), R.color.amber500))
                        .setContentTitle("Sage Mentorship")
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
