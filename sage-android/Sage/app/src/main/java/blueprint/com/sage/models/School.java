package blueprint.com.sage.models;

import java.util.List;

import lombok.Data;

/**
 * Created by charlesx on 10/14/15.
 */
public @Data class School {
    private int id;
    private String name;
    private float lat;
    private float lng;
    private String address;
    private int directorId;
    
    private User director;
    private List<User> users;

    private int studentCount;

    public School() {}

    public boolean hasLatLng() {
        return lat != 0.0 && lng != 0.0;
    }
}
