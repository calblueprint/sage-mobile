package blueprint.com.sage.models;

import lombok.Data;

/**
 * Created by kelseylam on 10/11/15.
 */
public @Data class Session {
    private String email;
    private String authenticationToken;
    private User user;
}
