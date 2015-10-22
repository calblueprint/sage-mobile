package blueprint.com.sage.models;

import java.util.Date;

/**
 * Created by kelseylam on 10/10/15.
 */
@Data
public class Announcement {
    private int mId;
    private Date mCreatedAt;
    private Date mUpdatedAt;
    private String mTitle;
    private int mSchoolId;
    private int mUserId;
    private int mCategory;

}
