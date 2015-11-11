package blueprint.com.sage.events.checkIns;

import blueprint.com.sage.models.CheckIn;

/**
 * Created by charlesx on 11/11/15.
 */
public class DeleteCheckInEvent {

    public CheckIn mCheckIn;

    public DeleteCheckInEvent(CheckIn checkIn) {
        mCheckIn = checkIn;
    }
}
