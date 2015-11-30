package blueprint.com.sage.events.checkIns;

import blueprint.com.sage.models.CheckIn;

/**
 * Created by charlesx on 11/23/15.
 */
public class CheckInEvent {

    private CheckIn checkIn;

    public CheckInEvent(CheckIn checkIn) {
        this.checkIn = checkIn;
    }
}
