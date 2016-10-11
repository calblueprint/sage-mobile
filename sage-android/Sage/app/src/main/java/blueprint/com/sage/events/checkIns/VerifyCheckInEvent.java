package blueprint.com.sage.events.checkIns;

import blueprint.com.sage.models.CheckIn;
import lombok.Data;

/**
 * Created by charlesx on 11/11/15.
 */
public @Data class VerifyCheckInEvent {

    private CheckIn checkIn;
    private int position;

    public VerifyCheckInEvent(CheckIn checkIn, int position) {
        this.checkIn = checkIn;
        this.position = position;
    }
}
