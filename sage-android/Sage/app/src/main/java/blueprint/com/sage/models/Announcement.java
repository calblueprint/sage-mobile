package blueprint.com.sage.models;

import com.fasterxml.jackson.annotation.JsonIgnore;

import org.joda.time.DateTime;
import org.joda.time.Period;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Data;

/**
 * Created by kelseylam on 10/24/15.
 */
public @Data class Announcement {
    private int id;
    private Date createdAt;
    private String title;
    private String body;
    private int schoolId;
    private int userId;
    private int category;
    private String userName;
    private String schoolName;

    private User user;
    private School school;

    @JsonIgnore
    public boolean isGeneral() {
        return category == 1;
    }

    @JsonIgnore
    public String getDate() {
        SimpleDateFormat format = new SimpleDateFormat("MMMM d, yyyy");
        return format.format(createdAt);
    }

    @JsonIgnore
    public String getTime() {
        DateTime dateTime = new DateTime(getCreatedAt());
        Period period = new Period(dateTime, DateTime.now());
        long seconds = period.getSeconds();
        long minutes = period.getMinutes();
        long hours = period.getHours();
        long days = period.getDays();
        long weeks = period.getWeeks();
        long months = period.getMonths();
        long years = period.getYears();
        if (years > 0) {
            if (years == 1) {
                return years + " year ago";
            }
            return years + " years ago";
        }
        if (months > 0) {
            if (months == 1) {
                return months + " month ago";
            }
            return months + " months ago";
        }
        if (weeks > 0) {
            if (weeks == 1) {
                return weeks + " week ago";
            }
            return weeks + " weeks ago";
        }
        if (days > 0) {
            if (days == 1) {
                return days + " day ago";
            }
            return days + " days ago";
        }
        if (hours > 0) {
            if (hours == 1) {
                return hours + " hour ago";
            }
            return hours + " hours ago";
        }
        if (minutes > 0) {
            if (minutes == 1) {
                return minutes + " minute ago";
            }
            return minutes + " minutes ago";
        } else {
            if (seconds == 1) {
                return seconds + " second ago";
            }
            return seconds + " seconds ago";
        }
    }
}
