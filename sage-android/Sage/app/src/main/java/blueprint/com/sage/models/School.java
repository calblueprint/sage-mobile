package blueprint.com.sage.models;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.google.android.gms.maps.model.LatLng;

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

    public School() {}

    public School(String name, String address, LatLng bounds) {
        this.name = name;
        this.address = address;
        if (bounds != null) {
            this.lat = (float) bounds.latitude;
            this.lng = (float) bounds.longitude;
        }
    }

    public boolean hasLatLng() {
        return lat != 0.0 && lng != 0.0;
    }
}
