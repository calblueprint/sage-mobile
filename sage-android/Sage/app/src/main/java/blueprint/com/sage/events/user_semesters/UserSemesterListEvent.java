package blueprint.com.sage.events.user_semesters;

import java.util.List;

import blueprint.com.sage.models.UserSemester;
import lombok.Data;

/**
 * Created by charlesx on 1/17/16.
 */
@Data
public class UserSemesterListEvent {
    private List<UserSemester> userSemesters;

    public UserSemesterListEvent(List<UserSemester> userSemesters) {
        this.userSemesters = userSemesters;
    }
}
