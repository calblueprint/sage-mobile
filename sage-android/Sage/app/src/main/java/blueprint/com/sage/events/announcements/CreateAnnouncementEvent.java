package blueprint.com.sage.events.announcements;

import blueprint.com.sage.models.Announcement;
import lombok.Data;

/**
 * Created by kelseylam on 12/5/15.
 */
public @Data class CreateAnnouncementEvent {

    private Announcement mAnnouncement;

    public CreateAnnouncementEvent(Announcement announcement) { mAnnouncement = announcement; }
}
