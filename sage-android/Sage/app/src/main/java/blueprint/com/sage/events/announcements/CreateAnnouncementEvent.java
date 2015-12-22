package blueprint.com.sage.events.announcements;

import blueprint.com.sage.models.Announcement;

/**
 * Created by kelseylam on 12/5/15.
 */
public class CreateAnnouncementEvent {

    public Announcement announcement;

    public CreateAnnouncementEvent(Announcement announcement) { this.announcement = announcement; }
}
