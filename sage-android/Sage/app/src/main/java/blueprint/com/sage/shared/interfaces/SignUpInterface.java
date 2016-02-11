package blueprint.com.sage.shared.interfaces;

import java.util.List;

import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;

/**
 * Created by charlesx on 2/11/16.
 */
public interface SignUpInterface {
    void makeUserRequest();
    User getUser();
    List<School> getSchools();
}
