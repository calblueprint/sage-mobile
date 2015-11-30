package blueprint.com.sage.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.util.List;

import blueprint.com.sage.network.serializers.SchoolSerializer;
import lombok.Data;

/**
 * Created by charlesx on 10/14/15.
 */
@JsonSerialize(using = SchoolSerializer.class)
public @Data class School {
    private int id;
    private String name;
    private float lat;
    private float lng;
    private String address;

    private User director;
    private List<User> users;

    @JsonIgnore
    private int directorId;

    public School() {}

    public boolean hasLatLng() {
        return lat != 0.0 && lng != 0.0;
    }
}
