package blueprint.com.sage.browse;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.browse.fragments.BrowseTabFragment;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.activities.NavigationAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 11/4/15.
 */
public class BrowseActivity extends NavigationAbstractActivity {

    private List<School> mSchools;
    private List<User> mUsers;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mSchools = new ArrayList<>();
        mUsers = new ArrayList<>();


        getUsersListRequest();
        FragUtils.replace(R.id.container, BrowseTabFragment.newInstance(), this);
    }

    public void getSchoolsListRequest() {
        Requests.Schools.with(this).makeListRequest(null);
    }
    public void getUsersListRequest() {
        Requests.Users.with(this).makeListRequest(null);
    }

    public void setUsers(List<User> users) { mUsers = users; }
    public List<User> getUsers() { return mUsers; }
    public void setSchools(List<School> schools) { mSchools = schools; }
    public List<School> getSchools() { return mSchools; }
}
