package blueprint.com.sage.events;

import java.util.ArrayList;

import blueprint.com.sage.models.Announcement;
import lombok.Data;

/**
 * Created by kelseylam on 11/7/15.
 */
public @Data class AnnouncementsListEvent {

    ArrayList<Announcement> announcements;

    public AnnouncementsListEvent(ArrayList<Announcement> announcements) {
        this.announcements = announcements;
    }
    
}
