package blueprint.com.sage.models;

import lombok.Data;

/**
 * Created by kelseylam on 10/11/15.
 */
public @Data class Session {
    private String mEmail;
    private String mAuthenticationToken;
    private User mUser;
}
