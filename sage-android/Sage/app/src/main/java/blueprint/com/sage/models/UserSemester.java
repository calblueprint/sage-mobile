package blueprint.com.sage.models;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Data;

/**
 * Created by charlesx on 1/9/16.
 */
@Data
public class UserSemester {
    private int id;
    private int semesterId;
    private int totalTime;
    private boolean completed;
    private int status;

    public final static int INACTIVE = 0;
    public final static int ACTIVE = 1;
    public final static String[] STATUS_SPINNER = { "Inactive", "Active" };

    @JsonIgnore
    public String getTimeString() {
        return String.valueOf(getTotalTime() / 60);
    }

    @JsonIgnore
    public boolean isActive() { return status == ACTIVE ; }
}
