package blueprint.com.sage.models;

import android.util.Log;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import blueprint.com.sage.utility.DateUtils;
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

    public CheckIn(String startTime, String endTime, User user, School school) {
        this.start = DateUtils.stringToDate(startTime);
        this.finish = DateUtils.stringToDate(endTime);
        this.user_id = user.getId();
        this.school_id = school.getId();
    }
}
