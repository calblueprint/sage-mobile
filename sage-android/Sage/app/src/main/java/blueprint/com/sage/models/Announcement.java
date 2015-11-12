package blueprint.com.sage.models;

import java.util.Date;

import lombok.Data;

/**
 * Created by kelseylam on 10/24/15.
 */
public @Data class Announcement {
    private int id;
    private Date createdAt;
    private String title;
    private String body;
    private int schoolId;
    private int userId;
    private String category;
    private String userName;
    private String schoolName;

    private User user;
    private String school;
}
