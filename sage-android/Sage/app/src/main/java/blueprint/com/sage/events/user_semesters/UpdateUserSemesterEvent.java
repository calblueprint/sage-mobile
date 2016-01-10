package blueprint.com.sage.events.user_semesters;

import blueprint.com.sage.models.UserSemester;
import lombok.Data;

/**
 * Created by charlesx on 1/9/16.
 */
@Data
public class UpdateUserSemesterEvent {
    private UserSemester userSemester;

    public UpdateUserSemesterEvent(UserSemester userSemester) { this.userSemester = userSemester; }
}
