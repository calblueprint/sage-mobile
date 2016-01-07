package blueprint.com.sage.events.announcements;

import blueprint.com.sage.models.Announcement;
import lombok.Data;

/**
 * Created by kelseylam on 1/4/16.
 */
public @Data class AnnouncementEvent {
    Announcement announcement;

    public AnnouncementEvent(Announcement announcement) {
        this.announcement = announcement;
    }

    public Announcement getAnnouncement() {
        return announcement;
    }
}
