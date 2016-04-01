package blueprint.com.sage.landing;

import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.drawable.AnimationDrawable;
import android.graphics.drawable.BitmapDrawable;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.Toast;

import com.crashlytics.android.Crashlytics;

import java.util.Timer;
import java.util.TimerTask;

import blueprint.com.sage.R;
import blueprint.com.sage.events.SessionEvent;
import blueprint.com.sage.main.MainActivity;
import blueprint.com.sage.models.Session;
import blueprint.com.sage.network.Requests;
import blueprint.com.sage.shared.activities.AbstractActivity;
import blueprint.com.sage.signIn.SignInActivity;
import blueprint.com.sage.signUp.UnverifiedActivity;
import blueprint.com.sage.utility.network.NetworkUtils;
import blueprint.com.sage.utility.view.LoadingView;
import butterknife.Bind;
import butterknife.ButterKnife;
import de.greenrobot.event.EventBus;
import io.fabric.sdk.android.Fabric;

/**
 * Created by kelseylam on 2/3/16.
 */
public class LandingActivity extends AbstractActivity {

    @Bind(R.id.landing_loading_view) LoadingView mLoadingView;
    @Bind(R.id.landing_layout) FrameLayout mLandingLayout;
    @Bind(R.id.landing_splash) ImageView mLandingSplash;

    private SharedPreferences mPreferences;
    private AnimationDrawable mAnimationDrawable;
    private int mTotalAnimationTime;
    private Timer mTimer;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Fabric.with(this, new Crashlytics());
        setContentView(R.layout.activity_landing);

        ButterKnife.bind(this);

        initializeViews();

        if (!NetworkUtils.isConnectedToInternet(this)) {
            Toast.makeText(this, "You're not connected to the internet!", Toast.LENGTH_SHORT).show();
            finish();
            return;
        }

        if (!NetworkUtils.isVerifiedUser(this, getSharedPreferences())) {
            startAnimation(SignInActivity.class);
            return;
        }

        Requests.Users.with(this).makeStateRequest(getUser());
    }

    @Override
    public void onStart() {
        super.onStart();
        EventBus.getDefault().register(this);
    }

    @Override
    public void onPause() {
        super.onPause();

        mAnimationDrawable.stop();
        for (int i = 0; i < mAnimationDrawable.getNumberOfFrames(); i++) {
            BitmapDrawable drawable = (BitmapDrawable) mAnimationDrawable.getFrame(i);
            drawable.getBitmap().recycle();
            drawable.setCallback(null);
        }

        mAnimationDrawable.setCallback(null);
        mAnimationDrawable = null;
    }

    @Override
    public void onStop() {
        super.onStop();
        EventBus.getDefault().unregister(this);
    }

    private void initializeViews() {
        mTimer = new Timer();

        mAnimationDrawable = (AnimationDrawable) mLandingSplash.getDrawable();
        int msPerFrame = getResources().getInteger(R.integer.splash_animation_frame);
        mTotalAnimationTime = mAnimationDrawable.getNumberOfFrames() * msPerFrame;
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
                mAnimationDrawable.start();

                TimerTask timerTask = new TimerTask() {
                    @Override
                    public void run() {
                        startActivity(cls);
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
        overridePendingTransition(R.anim.fade_in, R.anim.fade_out);
    }

    public void onEvent(SessionEvent event) {
        try {
            Session session = event.getSession();
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
}
