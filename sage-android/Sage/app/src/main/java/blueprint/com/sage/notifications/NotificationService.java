package blueprint.com.sage.notifications;

import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;

import com.google.android.gms.gcm.GcmListenerService;

import org.json.JSONException;
import org.json.JSONObject;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.requests.VerifyCheckInRequestsActivity;
import blueprint.com.sage.admin.requests.VerifyUserRequestsActivity;
import blueprint.com.sage.announcements.AnnouncementActivity;
import blueprint.com.sage.events.announcements.AnnouncementNotificationEvent;
import blueprint.com.sage.events.checkIns.CheckInNotificationEvent;
import blueprint.com.sage.events.users.SignUpNotificationEvent;
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
        int type = Integer.valueOf(data.getString("type"));
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
        Class<?> cls = null;

        switch(type) {
            case ANNOUNCEMENT_NOTIFICATION:
                cls = AnnouncementActivity.class;
                intentBundle.putString("announcement", getObjectStringFromJsonKey(object, "announcement"));
                break;
            case CHECK_IN_NOTIFICATION:
                cls = VerifyCheckInRequestsActivity.class;
                break;
            case SIGN_UP_NOTIFICATION:
                cls = VerifyUserRequestsActivity.class;
                break;
        }

        if (cls == null) {
            return;
        }

        Intent intent = new Intent(this, cls);
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
        EventBus.getDefault().post(
                new AnnouncementNotificationEvent(
                        getApplicationContext(), getObjectStringFromJsonKey(object, "announcement")));
    }

    private void sendCheckInNotification(String object) {
        EventBus.getDefault().post(
                new CheckInNotificationEvent(
                        getApplicationContext(), getObjectStringFromJsonKey(object, "check_in")));
    }

    private void sendSignUpNotification(String object) {
        EventBus.getDefault().post(
                new SignUpNotificationEvent(
                        getApplicationContext(), getObjectStringFromJsonKey(object, "user")));
    }

    private String getObjectStringFromJsonKey(String object, String key) {
        try {
            JSONObject jsonObject = new JSONObject(object);
            return jsonObject.getJSONObject(key).toString();
        } catch (JSONException e) {
            Log.e(getClass().toString(), e.toString());
        }

        return null;
    }
}
