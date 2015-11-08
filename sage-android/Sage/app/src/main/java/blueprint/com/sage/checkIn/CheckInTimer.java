package blueprint.com.sage.checkIn;

import android.app.Activity;
import android.os.Handler;

import java.util.Timer;
import java.util.TimerTask;

/**
 * Created by charlesx on 11/3/15.
 */
public class CheckInTimer {

    private Thread mThread;

    private Activity mActivity;
    private int mSleep;
    private Runnable mRunnable;

    // This is bad, but it'll do for now
    private Timer mTimer;
    private TimerTask mTimerTask;
    private Handler mHandler;


    public CheckInTimer(Activity activity, int sleep, final Runnable runnable) {
        mActivity = activity;
        mSleep = sleep;
        mRunnable = runnable;
        mHandler = new Handler();

        setUpTimer();
    }

    private void setUpTimer() {
        mTimerTask = new TimerTask() {
            @Override
            public void run() {
                mHandler.post(mRunnable);
            }
        };
    }

    public void start() {
        if (mTimer != null) stop();
        mTimer = new Timer();
        setUpTimer();
        mTimer.schedule(mTimerTask, 0, mSleep); //
    }

    public void stop() {
        if (mTimer != null) {
            mTimer.cancel();
            mTimer = null;
        }
    }
}
