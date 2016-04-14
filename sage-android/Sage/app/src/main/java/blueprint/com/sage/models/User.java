package blueprint.com.sage.models;

import android.app.Activity;
import android.graphics.Bitmap;
import android.util.Base64;
import android.widget.ImageView;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import java.io.ByteArrayOutputStream;
import java.util.List;

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
    private int volunteerType;
    private String password;
    private String currentPassword;
    private String passwordConfirmation;
    private String imageUrl;
    private int deviceType;
    private int deviceId;

    private UserSemester userSemester;
    private School school;
    private List<CheckIn> checkIns;

    @JsonIgnore
    private int schoolSelected = -1;

    @JsonIgnore
    private Bitmap profile;

    public final static int STUDENT = 0;
    public final static int ADMIN = 1;
    public final static int PRESIDENT = 2;

    public final static String[] VOLUNTEER_SPINNER = { "Volunteer", "One Unit", "Two Units" };
    public final static String[] ROLE_SPINNER = { "Student", "Admin" };
    public final static String[] ROLE_SPINNER_PRESIDENT = { "Student", "Admin", "President" };
    public final static String[] ROLES_LABEL = { "Inactive", "Admin", "President", "Director" };
    public final static String[] ABBREV_ROLES_LABEL = { "!", "A", "P", "D" };
    
    public User() {}

    @JsonIgnore
    public String getName() { return String.format("%s %s", firstName, lastName); }

    @JsonIgnore
    public String getHoursString() {
        return String.format("%d hrs/week", volunteerType + 1);
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

    public boolean getRemoveImage() {
        return profile == null;
    }

    /**
     * Loads user image into imageview
     */
    public void loadUserImage(Activity activity, ImageView imageView) {
        if (getImageUrl() == null) {
            ViewUtils.loadImage(activity, R.drawable.ic_account_circle_black_48dp, imageView);
        } else {
            ViewUtils.loadImage(activity, getImageUrl(), imageView);
        }
    }

    @JsonIgnore
    public boolean isStudent() { return role == STUDENT; }

    @JsonIgnore
    public boolean isAdmin() { return role == ADMIN || role == PRESIDENT; }

    @JsonIgnore
    public boolean isPresident() { return role == PRESIDENT; }
}
