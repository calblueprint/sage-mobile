package blueprint.com.sage.models;

import android.graphics.Bitmap;
import android.util.Base64;
import android.util.Log;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;

import java.io.ByteArrayOutputStream;

import blueprint.com.sage.serializers.UserSerializer;
import lombok.Data;

/**
 * Created by kelseylam on 10/11/15.
 * User model.
 */
@JsonSerialize(using = UserSerializer.class)
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

    private Bitmap profile;

    public final static String VOLUNTEER = "volunteer";
    public final static String ONE_UNIT = "one_unit";
    public final static String TWO_UNIT = "unit";

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
            case TWO_UNIT:
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
    public String getProfileData() {
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        profile.compress(Bitmap.CompressFormat.PNG, 100, stream);
        return Base64.encodeToString(stream.toByteArray(), Base64.DEFAULT);
    }
}
