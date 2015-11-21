package blueprint.com.sage.signUp;

import android.annotation.TargetApi;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;

import blueprint.com.sage.R;
import blueprint.com.sage.events.BackEvent;
import blueprint.com.sage.events.schools.SchoolListEvent;
import blueprint.com.sage.events.users.CreateUserEvent;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.signUp.fragments.SignUpPagerFragment;
import blueprint.com.sage.utility.network.NetworkManager;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.FragUtils;
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

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);

        mUser = new User();
        mSchools = new ArrayList<>();
        mManager = NetworkManager.getInstance(this);
        mPreferenceTag = getString(R.string.shared_preferences);
        mPreferences = getSharedPreferences(mPreferenceTag, MODE_PRIVATE);

        setStatusBarColor();
        makeSchoolRequest();


        FragUtils.replace(R.id.sign_up_container, SignUpPagerFragment.newInstance(), this);
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    @TargetApi(23)
    public void setStatusBarColor() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT)
            this.getWindow().setStatusBarColor(getResources().getColor(R.color.black, this.getTheme()));
    }

    private void makeSchoolRequest() {
        Requests.Schools.with(this).makeListRequest(null);
    }

    public void makeUserRequest() {
        Requests.Users.with(this).makeCreateUserRequest(getUser());
    }

    private void logInUser(Session session) {
        try {
            NetworkUtils.loginUser(session, this);
        } catch (Exception e) {
            Toast.makeText(this, "Something went wrong! Please try again.", Toast.LENGTH_SHORT).show();
        }
    }

    public void onEvent(CreateUserEvent event) { logInUser(event.getSession()); }
    public void onEvent(SchoolListEvent event) {
        setSchools(event.getSchools());
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
