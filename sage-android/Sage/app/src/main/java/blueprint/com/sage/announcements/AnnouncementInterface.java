package blueprint.com.sage.announcements;

import blueprint.com.sage.models.Announcement;

/**
 * Created by kelseylam on 1/29/16.
 */
public interface AnnouncementInterface {
    Announcement getAnnouncement();
    void setAnnouncement(Announcement announcement);
    int getType();
    void setType(int type);
}
