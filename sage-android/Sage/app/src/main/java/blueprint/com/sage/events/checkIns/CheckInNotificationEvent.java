package blueprint.com.sage.events.checkIns;

import android.content.Context;

import com.fasterxml.jackson.core.type.TypeReference;

import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.utility.network.NetworkUtils;
import lombok.Data;

/**
 * Created by charlesx on 6/2/16.
 */
@Data
public class CheckInNotificationEvent {

    private CheckIn checkIn;

    public CheckInNotificationEvent(Context context, String objectString) {
        this.checkIn = NetworkUtils.writeAsObject(context, objectString, new TypeReference<CheckIn>() {});
    }
}
