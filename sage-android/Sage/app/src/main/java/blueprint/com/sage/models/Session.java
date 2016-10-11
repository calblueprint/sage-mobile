package blueprint.com.sage.models;

import lombok.Data;

/**
 * Created by kelseylam on 10/11/15.
 * Session model (for authentication)
 */
public @Data class Session {
    private String email;
    private String authenticationToken;
    private User user;
    private School school;
    private Semester currentSemester;
}
