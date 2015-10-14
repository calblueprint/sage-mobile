package blueprint.com.sage.sign_up;

import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

import blueprint.com.sage.R;
import blueprint.com.sage.models.User;
import blueprint.com.sage.sign_up.fragments.SignUpPagerFragment;
import blueprint.com.sage.utility.view.FragUtil;

/**
 * Created by charlesx on 10/12/15.
 * Activity for signups
 */
public class SignUpActivity extends FragmentActivity {

    private User mUser;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);

        mUser = new User();
        FragUtil.replace(R.id.sign_up_container, SignUpPagerFragment.newInstance(), this);
    }

    public User getUser() {
        if (mUser == null) mUser = new User();
        return mUser;
    }

    public void setUser(User user) {
        mUser = user;
    }
}
