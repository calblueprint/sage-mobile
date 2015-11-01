package blueprint.com.sage.models;

import java.util.Date;

import lombok.Data;

/**
 * Created by charlesx on 10/17/15.
 * Check in model
 */
public @Data class CheckIn {
    private int id;
    private Date createdAt;
    private Date start;
    private Date finish;
    private int user_id;
    private int school_id;
    private boolean verified;
    private String comment;

    private User user;
    private School school;

    public CheckIn(Date start, Date end, User user, School school) {
        this.start = start;
        this.finish = end;
        this.user_id = user.getId();
        this.school_id = school.getId();
    }
}
