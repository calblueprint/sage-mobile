package blueprint.com.sage.models;

import com.fasterxml.jackson.annotation.JsonIgnore;

import org.joda.time.DateTime;

import java.util.Date;
import java.util.List;

import lombok.Data;

/**
 * Created by charlesx on 1/3/16.
 * The semester model
 */
public @Data class Semester {
    private int id;
    private Date start;
    private Date finish;
    private int season;

    private List<CheckIn> checkIns;
    private List<User> users;

    public static final String[] SEASONS = { "Fall", "Spring" };

    @JsonIgnore
    public int getYear() {
        return (new DateTime(start)).getYear();
    }

    @JsonIgnore
    @Override
    public String toString() {
        return String.format("%s %d", SEASONS[season], getYear());
    }
}
