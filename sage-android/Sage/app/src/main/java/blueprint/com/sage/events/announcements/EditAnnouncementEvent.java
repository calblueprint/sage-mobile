package blueprint.com.sage.events.announcements;

import blueprint.com.sage.models.Announcement;
import lombok.Data;

/**
 * Created by kelseylam on 1/7/16.
 */
public @Data class EditAnnouncementEvent {
    private Announcement mAnnouncement;

    public EditAnnouncementEvent(Announcement announcement) { mAnnouncement = announcement; }
}
