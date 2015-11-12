package blueprint.com.sage.models;

import android.graphics.Bitmap;
import android.util.Base64;
import android.util.Log;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.io.ByteArrayOutputStream;

import lombok.Data;

/**
 * Created by kelseylam on 10/11/15.
 * User model.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public @Data class User {
    private int id;
    private String email;
    private boolean verified;
    private String firstName;
    private String lastName;
    private int schoolId;
    private int directorId;
    private String role;
    private String volunteerType;
    private int totalHours;

    // Used for Sign Ups
    private int schoolPosition = -1;
    private int typePosition = -1;

    private String password;
    private String currentPassword;
    private String confirmPassword;

    @JsonIgnore
    private Bitmap profile;

    private String imageUrl;

    public final static String VOLUNTEER = "volunteer";
    public final static String ONE_UNIT = "one_unit";
    public final static String TWO_UNITS = "two_units";

    public User() {}

    @JsonIgnore
    public String getName() { return String.format("%s %s", firstName, lastName); }

    @JsonIgnore
    public void setTypePosition(int type) {
        switch (type) {
            case 0:
                volunteerType = VOLUNTEER;
            case 1:
                volunteerType = ONE_UNIT;
            case 2:
                volunteerType = TWO_UNITS;
            default:
                Log.e(getClass().toString(), "Invalid volunteer type");
                volunteerType = VOLUNTEER;
        }
    }

    /**
     * Gets integer of volunteer type
     */
    public int getVolunteerTypeString() {
        if (volunteerType == null) return 0;

        switch (volunteerType) {
            case VOLUNTEER:
                return 0;
            case ONE_UNIT:
                return 1;
            case TWO_UNITS:
                return 2;
            default:
                Log.e(getClass().toString(), "Invalid volunteer type");
                return 0;
        }
    }

    public final static String STUDENT = "student";
    public final static String ADMIN = "admin";

    /**
     * Gets integer of volunteer type
     */
    public int getRoleString() {
        if (volunteerType == null) return 0;

        switch (role) {
            case STUDENT:
                return 0;
            case ADMIN:
                return 1;
            default:
                Log.e(getClass().toString(), "Invalid volunteer type");
                return 0;
        }
    }

    /**
     * Compresses Profile Picture into a string
     * @return
     */
    @JsonIgnore
    public String getProfileData() {
        if (profile == null) return null;

        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        profile.compress(Bitmap.CompressFormat.PNG, 100, stream);
        return Base64.encodeToString(stream.toByteArray(), Base64.DEFAULT);
    }
}
