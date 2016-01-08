package blueprint.com.sage.events.announcements;

import blueprint.com.sage.models.Announcement;

/**
 * Created by kelseylam on 1/7/16.
 */
public class DeleteAnnouncementEvent {
    public Announcement announcement;

    public DeleteAnnouncementEvent(Announcement announcement) { this.announcement = announcement; }
}
