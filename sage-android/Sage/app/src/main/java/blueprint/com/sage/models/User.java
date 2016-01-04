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
    private int role;
    private int status;
    private int volunteerType;
    private int totalTime;
    private String password;
    private String currentPassword;
    private String passwordConfirmation;
    private String imageUrl;

    @JsonIgnore
    private int schoolSelected = -1;

    private School school;

    @JsonIgnore
    private Bitmap profile;

    public final static int STUDENT = 0;
    public final static int ADMIN = 1;

    public final static String[] VOLUNTEER_SPINNER = { "Volunteer", "One Unit", "Two Units" };
    public final static String[] ROLE_SPINNER = { "Student", "Admin" };

    public User() {}

    @JsonIgnore
    public String getName() { return String.format("%s %s", firstName, lastName); }

    @JsonIgnore
    public String getHoursString() {
        return String.format("%d hrs/week", volunteerType + 1);
    }

    @JsonIgnore
    public String getTimeString() {
        return String.valueOf(getTotalTime() / 60);
    }

    /**
     * Compresses Profile Picture into a string
     * @return
     */
    public String getData() {
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

    @JsonIgnore
    public boolean isAdmin() { return role == ADMIN; }
}
