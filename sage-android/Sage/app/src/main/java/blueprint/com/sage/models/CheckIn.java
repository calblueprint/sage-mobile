package blueprint.com.sage.models;

import com.fasterxml.jackson.annotation.JsonIgnore;

import org.joda.time.DateTime;

import java.util.Date;

import blueprint.com.sage.utility.view.DateUtils;
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

    public CheckIn() {}

    public CheckIn(Date start, Date end, User user, School school, String comment) {
        this.start = start;
        this.finish = end;
        this.user_id = user.getId();
        this.school_id = school.getId();
        this.comment = comment;
    }

    @JsonIgnore
    public String getTotalTime() {
        return DateUtils.timeDiff(new DateTime(start), new DateTime(finish));
    }

    public String getComment() { return comment == null ? null : comment; }
}
