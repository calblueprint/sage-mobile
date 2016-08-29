package blueprint.com.sage.events.semesters;

import blueprint.com.sage.models.APISuccess;
import lombok.Data;

/**
 * Created by charlesx on 4/14/16.
 */
@Data
public class ExportSemesterEvent {
    private APISuccess apiSuccess;

    public ExportSemesterEvent(APISuccess apiSuccess) { this.apiSuccess = apiSuccess; }
}
