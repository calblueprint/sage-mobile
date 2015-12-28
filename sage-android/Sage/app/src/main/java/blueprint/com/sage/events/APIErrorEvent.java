package blueprint.com.sage.events;

import blueprint.com.sage.models.APIError;
import lombok.Data;

/**
 * Created by charlesx on 12/22/15.
 */
public @Data class APIErrorEvent {
    private APIError apiError;

    public APIErrorEvent(APIError error) {
        this.apiError = error;
    }
}
