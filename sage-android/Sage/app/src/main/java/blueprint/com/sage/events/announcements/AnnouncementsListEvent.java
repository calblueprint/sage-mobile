package blueprint.com.sage.events.announcements;

import java.util.ArrayList;

import blueprint.com.sage.models.Announcement;
import lombok.Data;

/**
 * Created by kelseylam on 11/7/15.
 */
public @Data class AnnouncementsListEvent {

    private ArrayList<Announcement> mAnnouncements;

    public AnnouncementsListEvent(ArrayList<Announcement> announcements) {
        mAnnouncements = announcements;
    }
    
}
