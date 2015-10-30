package blueprint.com.sage.models;

import android.util.Log;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

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
        this.start = parseTime(startTime);
        this.finish = parseTime(endTime);
        this.user_id = user.getId();
        this.school_id = school.getId();
    }

    private Date parseTime(String time) {
        DateFormat format = new SimpleDateFormat("yyyy/MM/dd HH:mm", Locale.ENGLISH);
        Date date = null;

        try {
            date = format.parse(time);
        } catch (ParseException e) {
            Log.e(getClass().toString(), e.toString());
        }

        return date;
    }
}
