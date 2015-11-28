package blueprint.com.sage.models;

import android.app.Activity;
import android.graphics.Bitmap;
import android.util.Base64;
import android.widget.ImageView;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.io.ByteArrayOutputStream;

import blueprint.com.sage.R;
import blueprint.com.sage.utility.view.ViewUtils;
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
    private String password;
    private String currentPassword;
    private String confirmPassword;
    private String imageUrl;
    private boolean active;

    private School school;

    // Used for Sign Ups
    private int schoolPosition = -1;
    private int typePosition = -1;

    @JsonIgnore
    private Bitmap profile;

    public final static String[] VOLUNTEER_TYPES = { "volunteer", "one_unit", "two_units" };
    public final static String[] ROLES = { "student", "admin" };

    public final static String[] VOLUNTEER_SPINNER = { "Volunteer", "One Unit", "Two Units" };
    public final static String[] ROLE_SPINNER = { "Student", "Admin" };

    public User() {}

    @JsonIgnore
    public String getName() { return String.format("%s %s", firstName, lastName); }

    @JsonIgnore
    public String getHoursString() {
        int hours = 0;
        for (int i = 0; i < VOLUNTEER_TYPES.length; i++) {
            if (volunteerType.equals(VOLUNTEER_TYPES[i]))
                hours = i + 1;
        }

        return String.format("%d hrs/week", hours);
    }

    /**
     * Gets integer of volunteer type
     */
    @JsonIgnore
    public int getVolunteerTypeInt() {
        for (int i = 0; i < VOLUNTEER_TYPES.length; i++)
            if (volunteerType.equals(VOLUNTEER_TYPES[i]))
                return i;
        return 0;
    }

    @JsonIgnore
    public void setVolunteerTypeInt(int type) {
        volunteerType = VOLUNTEER_TYPES[type];
    }

    @JsonIgnore
    public void setRoleInt(int type) {
        role = ROLES[type];
    }

    @JsonIgnore
    public int getRoleInt() {
        for (int i = 0; i < VOLUNTEER_TYPES.length; i++)
            if (volunteerType.equals(VOLUNTEER_TYPES[i]))
                return i;
        return 0;
    }

    @JsonIgnore
    public String getRoleString() {
        for (int i = 0; i < ROLES.length; i++)
            if (role.equals(ROLES[i]))
                return ROLE_SPINNER[i];
        return "Student";
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

    /**
     * Loads user image into imageview
     */
    public void loadUserImage(Activity activity, ImageView imageView) {
        if (getImageUrl() == null) {
            ViewUtils.loadImage(activity, R.drawable.default_profile, imageView);
        } else {
            ViewUtils.loadImage(activity, getImageUrl(), imageView);
        }
    }
}
