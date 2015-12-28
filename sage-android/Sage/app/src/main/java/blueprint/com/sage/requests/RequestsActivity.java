package blueprint.com.sage.requests;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.requests.fragments.RequestTabPagerFragment;
import blueprint.com.sage.shared.activities.BackAbstractActivity;
import blueprint.com.sage.shared.interfaces.CheckInsInterface;
import blueprint.com.sage.shared.interfaces.UsersInterface;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 11/10/15.
 */
public class RequestsActivity extends BackAbstractActivity
                              implements CheckInsInterface, UsersInterface {

    private List<CheckIn> mCheckIns;
    private List<User> mUsers;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mCheckIns = new ArrayList<>();
        mUsers = new ArrayList<>();

        getCheckInListRequest();
        getUsersListRequest();
        FragUtils.replace(R.id.container, RequestTabPagerFragment.newInstance(), this);
    }

    public void setCheckIns(List<CheckIn> checkIns) {
        mCheckIns = checkIns;
    }

    public List<CheckIn> getCheckIns() { return mCheckIns; }

    public void setUsers(List<User> users) {
        mUsers = users;
    }

    public List<User> getUsers() { return mUsers; }

    public void getCheckInListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("verified", "false");

        Requests.CheckIns.with(this).makeListRequest(queryParams);
    }

    public void getUsersListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("verified", "false");

        Requests.Users.with(this).makeListRequest(queryParams);

    }

}
