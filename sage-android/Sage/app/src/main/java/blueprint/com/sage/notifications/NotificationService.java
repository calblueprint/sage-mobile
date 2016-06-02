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
import blueprint.com.sage.events.announcements.AnnouncementNotificationEvent;
import blueprint.com.sage.events.checkIns.CheckInNotificationEvent;
import blueprint.com.sage.events.users.SignUpNotificationEvent;
import blueprint.com.sage.main.MainActivity;
import blueprint.com.sage.utility.network.NetworkUtils;
import de.greenrobot.event.EventBus;

/**
 * Created by kelseylam on 3/30/16.
 */
public class NotificationService extends GcmListenerService {

    public static final int NOTIFICATION_ID = 1;
    private NotificationManager mNotificationManager;

    // Notification types;
    public static final int ANNOUNCEMENT_NOTIFICATION = 0;
    public static final int CHECK_IN_NOTIFICATION = 1;
    public static final int SIGN_UP_NOTIFICATION = 2;

    @Override
    public void onMessageReceived(String from, Bundle data) {
        String message = data.getString("message");
        int type = data.getInt("type");
        String object = data.getString("object");

        if (NetworkUtils.isVerifiedUser(getBaseContext())) {
            handleNotification(message, type, object);
        }
    }

    private void handleNotification(String message, int type, String object) {
        if (type == ANNOUNCEMENT_NOTIFICATION && hasSubscriber(AnnouncementNotificationEvent.class)) {
            sendAnnouncementNotifications(object);
        } else if (type == CHECK_IN_NOTIFICATION && hasSubscriber(CheckInNotificationEvent.class)) {
            sendCheckInNotification(object);
        } else if (type == SIGN_UP_NOTIFICATION && hasSubscriber(SignUpNotificationEvent.class)) {
            sendSignUpNotification(object);
        } else {
            sendNotification(message, type, object);
        }
    }

    private boolean hasSubscriber(Class<?> cls) {
        return EventBus.getDefault().hasSubscriberForEvent(cls);
    }

    private void sendNotification(String message, int type, String object) {
        NotificationCompat.Builder mBuilder =
                new NotificationCompat.Builder(this)
                        .setSmallIcon(R.drawable.notification)
                        .setColor(ContextCompat.getColor(getBaseContext(), R.color.amber500))
                        .setContentTitle("Sage Mentorship")
                        .setStyle(new NotificationCompat.BigTextStyle())
                        .setContentText(message)
                        .setAutoCancel(true);

        Bundle intentBundle = new Bundle();
        intentBundle.putInt("type", type);
        intentBundle.putString("object", object);

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

    private void sendAnnouncementNotifications(String object) {
        EventBus.getDefault().post(new AnnouncementNotificationEvent(getApplicationContext(), object));
    }

    private void sendCheckInNotification(String object) {
        EventBus.getDefault().post(new CheckInNotificationEvent(getApplicationContext(), object));
    }

    private void sendSignUpNotification(String object) {
        EventBus.getDefault().post(new SignUpNotificationEvent(getApplicationContext(), object));
    }
}
