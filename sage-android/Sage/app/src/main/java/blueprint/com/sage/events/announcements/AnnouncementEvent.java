package blueprint.com.sage.events.announcements;

import blueprint.com.sage.models.Announcement;
import lombok.Data;

/**
 * Created by kelseylam on 1/4/16.
 */
public @Data class AnnouncementEvent {

    private Announcement mAnnouncement;

    public AnnouncementEvent(Announcement announcement) {
        mAnnouncement = announcement;
    }
}
