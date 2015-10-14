package blueprint.com.sage.models;

import java.util.Date;

import lombok.Data;

/**
 * Created by kelseylam on 10/11/15.
 */
public @Data class User {
    private int mId;
    private Date mCreatedAt;
    private Date mUpdatedAt;
    private String mEmail;
    private String mEncryptedPassword;
    private boolean mVerified;
    private String mFirstName;
    private String mLastName;
    private String mAuthenticationToken;
    private String mRole;
    private int mSchoolId;
    private int mDirectorId;
    private String mVolunteerType;
    private int mTotalHours;
}
