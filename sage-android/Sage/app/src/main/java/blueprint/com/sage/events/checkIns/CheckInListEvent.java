package blueprint.com.sage.events.checkIns;

import java.util.List;

import blueprint.com.sage.models.CheckIn;
import lombok.Data;

/**
 * Created by charlesx on 11/11/15.
 */
public @Data class CheckInListEvent {

    private List<CheckIn> checkIns;

    public CheckInListEvent(List<CheckIn> checkIns) {
        this.checkIns = checkIns;
    }
}
