package blueprint.com.sage.models;

import lombok.Data;

/**
 * Created by charlesx on 4/9/16.
 */
@Data
public class APIResponse {
    private String message;

    public APIResponse(String message) { this.message = message; }
}
