package blueprint.com.sage.admin.browse;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.admin.browse.fragments.BrowseUserListFragment;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.shared.interfaces.UsersInterface;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 12/28/15.
 */
public class BrowseUsersActivity extends BackAbstractActivity implements UsersInterface {
    private List<User> mUsers;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mUsers = new ArrayList<>();
        FragUtils.replace(R.id.container, BrowseUserListFragment.newInstance(), this);
    }

    public void setUsers(List<User> users) { mUsers = users; }
    public List<User> getUsers() { return mUsers; }

    public void getUsersListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("sort_name", "true");
        Requests.Users.with(this).makeListRequest(queryParams);
    }
}
