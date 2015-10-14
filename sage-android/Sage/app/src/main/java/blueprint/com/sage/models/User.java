package blueprint.com.sage.models;

import java.util.Date;

import lombok.Data;

/**
 * Created by kelseylam on 10/11/15.
 */
public @Data class User {
    private int id;
    private Date createdAt;
    private Date updatedAt;
    private String email;
    private String encryptedPassword;
    private boolean verified;
    private String firstName;
    private String lastName;
    private String authenticationToken;
    private String role;
    private int schoolId;
    private int directorId;
    private String volunteerType;
    private int totalHours;
    private String password;
    private String confirmPassword;

    // Used for Sign Ups
    private int schoolPosition = -1;
    private int typePosition = -1;
}