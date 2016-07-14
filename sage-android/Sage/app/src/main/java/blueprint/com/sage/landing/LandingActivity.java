package blueprint.com.sage.landing;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.Toast;

import com.crashlytics.android.Crashlytics;

import java.util.Timer;
import java.util.TimerTask;

import blueprint.com.sage.R;
import blueprint.com.sage.events.APIErrorEvent;
import blueprint.com.sage.events.SessionEvent;
import blueprint.com.sage.events.users.RegisterUserEvent;
import blueprint.com.sage.main.MainActivity;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.models.User;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.notifications.RegistrationIntentService;
import blueprint.com.sage.shared.activities.AbstractActivity;
import blueprint.com.sage.signIn.SignInActivity;
import blueprint.com.sage.signUp.UnverifiedActivity;
import blueprint.com.sage.utility.RegistrationUtils;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.LoadingView;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;
import io.fabric.sdk.android.Fabric;
import pl.droidsonroids.gif.GifDrawable;
import pl.droidsonroids.gif.GifImageView;

/**
 * Created by kelseylam on 2/3/16.
 */
public class LandingActivity extends AbstractActivity {

    @Bind(R.id.landing_loading_view) LoadingView mLoadingView;
    @Bind(R.id.landing_splash) GifImageView mLandingSplash;

    private GifDrawable mSplashDrawable;
    private int mTotalAnimationTime;
    private Timer mTimer;

    private SharedPreferences mPreferences;
    private BroadcastReceiver mRegistrationBroadcastReceiver;
    private String mRegistrationId;

    private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private static final String TAG = "LandingActivity";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_landing);

        ButterKnife.bind(this);

        initializeViews();
        mPreferences = getSharedPreferences();

        if (!NetworkUtils.isConnectedToInternet(this)) {
            Toast.makeText(this, "You're not connected to the internet!", Toast.LENGTH_SHORT).show();
            finish();
            return;
        }

        if (!NetworkUtils.isVerifiedUser(this)) {
            startAnimation(SignInActivity.class);
            return;
        }

        mRegistrationBroadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                makeRegistrationRequest(intent);
            }
        };

        RegistrationUtils.registerReceivers(this, mRegistrationBroadcastReceiver);

        if (RegistrationUtils.getRegistrationId(this).isEmpty() && RegistrationUtils.checkPlayServices(this)) {
            Intent intent = new Intent(this, RegistrationIntentService.class);
            startService(intent);
        } else {
            Requests.Users.with(this).makeStateRequest(getUser());
        }
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        RegistrationUtils.registerReceivers(this, mRegistrationBroadcastReceiver);
    }

    @Override
    protected void onPause() {
        super.onPause();
        RegistrationUtils.unregisterReceivers(this, mRegistrationBroadcastReceiver);
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    private void initializeViews() {
        mTimer = new Timer();

        mSplashDrawable = (GifDrawable) mLandingSplash.getDrawable();
        mSplashDrawable.stop();
        mSplashDrawable.setSpeed(1.75f);
        mTotalAnimationTime = mSplashDrawable.getDuration();
    }

    private void startAnimation(Session session) {
        try {
            NetworkUtils.setSession(this, session);
            if (session.getUser().isVerified()) {
                startAnimation(MainActivity.class);
            } else {
                startAnimation(UnverifiedActivity.class);
            }
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
    }

    private void startAnimation(final Class<?> cls) {
        Animation fadeOutAnimation = AnimationUtils.loadAnimation(this, R.anim.fade_out);
        fadeOutAnimation.setDuration(500);
        fadeOutAnimation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }

            @Override
            public void onAnimationEnd(Animation animation) {
                mLoadingView.setVisibility(View.GONE);
                mSplashDrawable.start();

                TimerTask timerTask = new TimerTask() {
                    @Override
                    public void run() {
                        runOnUiThread(
                                new Runnable() {
                                    @Override
                                    public void run() {
                                        mLandingSplash.setVisibility(View.GONE);
                                        mSplashDrawable.stop();
                                        startActivity(cls);
                                    }
                                });

                    }
                };

                mTimer.schedule(timerTask, mTotalAnimationTime);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {
            }
        });

        mLoadingView.setVisibility(View.VISIBLE);
        mLoadingView.startAnimation(fadeOutAnimation);
    }

    private void startActivity(Class<?> cls) {
        Intent intent = new Intent(this, cls);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK |
                Intent.FLAG_ACTIVITY_CLEAR_TASK);

        startActivity(intent);
        overridePendingTransition(0, R.anim.splash_fade_out);
    }

    private void startActivity() {
        if (getUser().isVerified()) {
            startAnimation(MainActivity.class);
        } else {
            startAnimation(UnverifiedActivity.class);
        }
    }

    private void makeRegistrationRequest(Intent intent) {
        Bundle bundle = intent.getExtras();
        mRegistrationId = bundle.getString(getString(R.string.registration_token));

        User user = getUser();
        user.setDeviceType(RegistrationUtils.DEVICE_TYPE);
        user.setDeviceId(mRegistrationId);

        Requests.Users.with(this).makeRegistrationRequest(user);
    }

    public void onEvent(SessionEvent event) {
        try {
            Session session = event.getSession();
            NetworkUtils.setSession(this, session);
            startActivity();
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
        startAnimation(event.getSession());
    }

    public void onEvent(RegisterUserEvent event) {
        mPreferences.edit()
                .putString(getString(R.string.registration_token), mRegistrationId)
                .putInt(getString(R.string.app_version), RegistrationUtils.getAppVersion(this))
                .apply();
        startAnimation(event.getSession());
    }

    public void onEvent(APIErrorEvent event) { startActivity(); }
}
