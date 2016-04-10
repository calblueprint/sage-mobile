package blueprint.com.sage.events.sessions;

import blueprint.com.sage.models.APISuccess;
import lombok.Data;

/**
 * Created by charlesx on 4/10/16.
 */
@Data
public class ResetPasswordEvent {
    private APISuccess apiSuccess;

    public ResetPasswordEvent(APISuccess success) { this.apiSuccess = apiSuccess; }
}
