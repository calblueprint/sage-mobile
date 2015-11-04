package blueprint.com.sage.signUp;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;
import android.widget.Toast;

import com.android.volley.Response;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.models.APIError;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.schools.SchoolListRequest;
import blueprint.com.sage.network.users.CreateUserRequest;
import blueprint.com.sage.signUp.events.BackEvent;
import blueprint.com.sage.signUp.fragments.SignUpPagerFragment;
import blueprint.com.sage.utility.network.NetworkManager;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtil;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 10/12/15.
 * Activity for signups
 */
public class SignUpActivity extends FragmentActivity {

    private User mUser;
    private List<School> mSchools;

    private SharedPreferences mPreferences;
    private String mPreferenceTag;

    private NetworkManager mManager;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);

        mUser = new User();
        mSchools = new ArrayList<>();
        mManager = NetworkManager.getInstance(this);
        mPreferenceTag = getString(R.string.shared_preferences);
        mPreferences = getSharedPreferences(mPreferenceTag, MODE_PRIVATE);

        makeSchoolRequest();
        FragUtil.replace(R.id.sign_up_container, SignUpPagerFragment.newInstance(), this);
    }

    private void makeSchoolRequest() {
        SchoolListRequest request = new SchoolListRequest(this,
            new Response.Listener<ArrayList<School>>() {
                @Override
                public void onResponse(ArrayList<School> schools) {
                    setSchools(schools);
                }
            },
            new Response.Listener<APIError>() {
                @Override
                public void onResponse(APIError o) {
                    Log.e(getClass().toString(), o.toString());
            }
        });

        mManager.getRequestQueue().add(request);
    }

    public void makeUserRequest() {
        CreateUserRequest request = new CreateUserRequest(this, getUser(),
                new Response.Listener<Session>() {
                    @Override
                    public void onResponse(Session session) {
                        logInUser(session);
                    }
                },
                new Response.Listener() {
                    @Override
                    public void onResponse(Object o) {
                       Log.e(getClass().toString(), o.toString());
                    }
                });
        mManager.getRequestQueue().add(request);
    }

    private void logInUser(Session session) {
        try {
            NetworkUtils.loginUser(session, this);
        } catch (Exception e) {
            Toast.makeText(this, "Something went wrong! Please try again.", Toast.LENGTH_SHORT).show();
        }
    }

    public User getUser() {
        if (mUser == null) mUser = new User();
        return mUser;
    }

    public void setUser(User user) {
        mUser = user;
    }

    public List<School> getSchools() {
        if (mSchools == null) mSchools = new ArrayList<>();
        return mSchools;
    }

    public void setSchools(List<School> schools) {
        mSchools = schools;
    }

    @Override
    public void onBackPressed() {
        EventBus.getDefault().post(new BackEvent());
    }
}
