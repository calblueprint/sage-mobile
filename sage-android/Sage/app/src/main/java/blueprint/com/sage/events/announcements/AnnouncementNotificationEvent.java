package blueprint.com.sage.events.announcements;

import android.content.Context;

import com.fasterxml.jackson.core.type.TypeReference;

import blueprint.com.sage.models.Announcement;
import blueprint.com.sage.utility.network.NetworkUtils;
import lombok.Data;

/**
 * Created by charlesx on 6/2/16.
 */
@Data
public class AnnouncementNotificationEvent {

    private Announcement announcement;

    public AnnouncementNotificationEvent(Context context, String objectString) {
        this.announcement =
                NetworkUtils.writeAsObject(context, objectString, new TypeReference<Announcement>() {});
    }
}
