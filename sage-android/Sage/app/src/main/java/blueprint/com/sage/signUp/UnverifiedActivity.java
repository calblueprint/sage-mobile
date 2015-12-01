package blueprint.com.sage.signUp;

import android.os.Bundle;
import android.util.Log;

import blueprint.com.sage.R;
import blueprint.com.sage.events.users.UserEvent;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.activities.AbstractActivity;
import blueprint.com.sage.shared.views.CircleImageView;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.ViewUtils;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 10/24/15.
 * Activity shown when a user isn't verified yet.
 */
public class UnverifiedActivity extends AbstractActivity {

    @Bind(R.id.unverified_photo_circle) CircleImageView mImageView;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_unverified);
        ButterKnife.bind(this);

        initializeViews();
        initializeProfilePhoto();
        refreshUser();
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

    private void initializeViews() {
        ViewUtils.setStatusBarColor(this, R.color.white);
    }

    private void initializeProfilePhoto() {
        mUser.loadUserImage(this, mImageView);
    }

    public void refreshUser() {
        Requests.Users.with(this).makeShowRequest(mUser);
    }

    public void onEvent(UserEvent event) { checkUser(event.getUser()); }

    private void checkUser(User user) {
        if (user.isVerified()) {
            try {
                NetworkUtils.setUser(this, user);
                NetworkUtils.loginUser(this);
            } catch (Exception e) {
                Log.e(getClass().toString(), e.toString());
            }
        }
    }
}
