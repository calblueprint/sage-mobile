package blueprint.com.sage.models;

import java.util.Date;

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
}
