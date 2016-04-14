package blueprint.com.sage.network.semesters;

import android.app.Activity;

import com.android.volley.Response;

import org.json.JSONException;

import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.network.BaseRequest;

/**
 * Created by charlesx on 4/13/16.
 */
public class ExportSemesterRequest extends BaseRequest {
    public ExportSemesterRequest(Activity activity, Semester semester,
                                 Response.Listener<APISuccess> onSuccess,
                                 Response.Listener<APIError> onError) {
        
    }
}
