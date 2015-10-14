package blueprint.com.sage.models;

import lombok.Data;

/**
 * Created by charlesx on 10/14/15.
 */
public @Data class School {
    private int id;
    private String name;
    private float lat;
    private float lng;
}
