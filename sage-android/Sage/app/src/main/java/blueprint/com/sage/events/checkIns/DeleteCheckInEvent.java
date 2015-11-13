package blueprint.com.sage.events.checkIns;

import blueprint.com.sage.models.CheckIn;
import lombok.Data;

/**
 * Created by charlesx on 11/11/15.
 */
public @Data class DeleteCheckInEvent {

    public CheckIn checkIn;

    public DeleteCheckInEvent(CheckIn checkIn) {
        this.checkIn = checkIn;
    }
}
