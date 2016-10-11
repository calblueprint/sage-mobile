package blueprint.com.sage.signUp;

import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
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
import butterknife.OnClick;
import de.greenrobot.event.EventBus;

/**
 * Created by charlesx on 10/24/15.
 * Activity shown when a user isn't verified yet.
 */
public class UnverifiedActivity extends AbstractActivity implements SwipeRefreshLayout.OnRefreshListener{

    @Bind(R.id.unverified_photo_circle) CircleImageView mImageView;
    @Bind(R.id.unverified_refresh) SwipeRefreshLayout mRefreshLayout;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_unverified);
        ButterKnife.bind(this);

        initializeViews();
        initializeProfilePhoto();
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onResume() {
        super.onResume();
        onRefresh();
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    private void initializeViews() {
        ViewUtils.setStatusBarColor(this, R.color.black);
        mRefreshLayout.setOnRefreshListener(this);
    }

    private void initializeProfilePhoto() {
        mUser.loadUserImage(this, mImageView);
    }

    @Override
    public void onRefresh() { Requests.Users.with(this).makeShowRequest(mUser, null); }


    @OnClick(R.id.unverified_log_out)
    public void onLogOut() { NetworkUtils.logoutCurrentUser(this); }

    public void onEvent(UserEvent event) {
        mRefreshLayout.setRefreshing(false);
        checkUser(event.getUser());
    }

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
