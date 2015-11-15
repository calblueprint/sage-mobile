package blueprint.com.sage.requests;

import android.os.Bundle;

import com.android.volley.Response;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.checkIns.CheckInListEvent;
import blueprint.com.sage.events.checkIns.DeleteCheckInEvent;
import blueprint.com.sage.events.checkIns.VerifyCheckInEvent;
import blueprint.com.sage.events.users.DeleteUserEvent;
import blueprint.com.sage.events.users.UserListEvent;
import blueprint.com.sage.events.users.VerifyUserEvent;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.CheckIn;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.check_ins.CheckInListRequest;
import blueprint.com.sage.network.check_ins.DeleteCheckInRequest;
import blueprint.com.sage.network.check_ins.VerifyCheckInRequest;
import blueprint.com.sage.network.users.DeleteUserRequest;
import blueprint.com.sage.network.users.UserListRequest;
import blueprint.com.sage.network.users.VerifyUserRequest;
import blueprint.com.sage.requests.fragments.RequestTabPagerFragment;
import blueprint.com.sage.shared.activities.NavigationAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 11/10/15.
 */
public class RequestsActivity extends NavigationAbstractActivity {

    private List<CheckIn> mCheckIns;
    private List<User> mUsers;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mCheckIns = new ArrayList<>();
        mUsers = new ArrayList<>();

        makeCheckInListRequest();
        makeUsersListRequest();
        FragUtils.replace(R.id.container, RequestTabPagerFragment.newInstance(), this);
    }

    public void setCheckIns(List<CheckIn> checkIns) {
        mCheckIns = checkIns;
        EventBus.getDefault().post(new CheckInListEvent());
    }
    public List<CheckIn> getCheckIns() { return mCheckIns; }

    public void setUsers(List<User> users) {
        mUsers = users;
        EventBus.getDefault().post(new UserListEvent());
    }
    public List<User> getUsers() { return mUsers; }

    public void makeCheckInListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("verified", "false");

        CheckInListRequest request = new CheckInListRequest(this, queryParams,
            new Response.Listener<ArrayList<CheckIn>>() {
                @Override
                public void onResponse(ArrayList<CheckIn> checkIns) {
                    setCheckIns(checkIns);
                }
            },
            new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError error) {

            }
        });

        getNetworkManager().getRequestQueue().add(request);
    }

    public void makeDeleteCheckInRequest(CheckIn checkIn, final int position) {
        DeleteCheckInRequest request = new DeleteCheckInRequest(this, checkIn,
                new Response.Listener<CheckIn>() {
                    @Override
                    public void onResponse(CheckIn checkIn) {
                        EventBus.getDefault().post(new DeleteCheckInEvent(checkIn, position));
                    }
                },
                new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {

                    }
                });

        getNetworkManager().getRequestQueue().add(request);
    }

    public void makeVerifyCheckInRequest(CheckIn checkIn, final int position) {
        VerifyCheckInRequest request = new VerifyCheckInRequest(this, checkIn,
                new Response.Listener<CheckIn>() {
                    @Override
                    public void onResponse(CheckIn checkIn) {
                        EventBus.getDefault().post(new VerifyCheckInEvent(checkIn, position));
                    }
                },
                new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {

                    }
                });

        getNetworkManager().getRequestQueue().add(request);
    }

    public void makeUsersListRequest() {
        HashMap<String, String> queryParams = new HashMap<>();
        queryParams.put("verified", "false");

        UserListRequest request = new UserListRequest(this, queryParams,
                new Response.Listener<ArrayList<User>>() {
                    @Override
                    public void onResponse(ArrayList<User> users) {

                    }
                },
                new Response.Listener<APIError>() {
                    @Override
                    public void onResponse(APIError error) {

                    }
                });

        getNetworkManager().getRequestQueue().add(request);
    }

    public void makeVerifyUserRequest(User user, final int position) {
        VerifyUserRequest request = new VerifyUserRequest(this, user, new Response.Listener<User>() {
            @Override
            public void onResponse(User user) {
                EventBus.getDefault().post(new VerifyUserEvent(user, position));
            }
        }, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError error) {

            }
        });

        getNetworkManager().getRequestQueue().add(request);
    }

    public void makeDeleteUserRequest(User user, final int position) {
        DeleteUserRequest request = new DeleteUserRequest(this, user, new Response.Listener<User>() {
            @Override
            public void onResponse(User user) {
                EventBus.getDefault().post(new DeleteUserEvent(user, position));
            }
        }, new Response.Listener<APIError>() {
            @Override
            public void onResponse(APIError error) {

            }
        });

        getNetworkManager().getRequestQueue().add(request);
    }
}
