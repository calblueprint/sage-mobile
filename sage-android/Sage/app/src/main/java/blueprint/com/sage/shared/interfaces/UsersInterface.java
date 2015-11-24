package blueprint.com.sage.shared.interfaces;

import java.util.List;

import blueprint.com.sage.models.User;

/**
 * Created by charlesx on 11/23/15.
 */
public interface UsersInterface {
    List<User> getUsers();
    void setUsers(List<User> users);
    void getUsersListRequest();
}
