package blueprint.com.sage.events.announcements;

import blueprint.com.sage.models.Announcement;
import lombok.Data;

/**
 * Created by kelseylam on 1/7/16.
 */
public @Data class DeleteAnnouncementEvent {
    private Announcement mAnnouncement;

    public DeleteAnnouncementEvent(Announcement announcement) { mAnnouncement = announcement; }
}
