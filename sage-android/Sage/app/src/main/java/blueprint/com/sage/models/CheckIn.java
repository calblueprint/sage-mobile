package blueprint.com.sage.models;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.Date;

import blueprint.com.sage.network.serializers.CheckInSerializer;
import lombok.Data;

/**
 * Created by charlesx on 10/17/15.
 * Check in model
 */
@JsonSerialize(using = CheckInSerializer.class)
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

    public CheckIn() {}

    public CheckIn(Date start, Date end, User user, School school, String comment) {
        this.start = start;
        this.finish = end;
        this.user_id = user.getId();
        this.school_id = school.getId();
        this.comment = comment;
    }
}
