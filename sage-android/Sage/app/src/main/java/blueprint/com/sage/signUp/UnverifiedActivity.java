package blueprint.com.sage.signUp;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.activities.AbstractActivity;
import blueprint.com.sage.shared.views.CircleImageView;
import butterknife.Bind;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/24/15.
 * Activity shown when a user isn't verified yet.
 */
public class UnverifiedActivity extends AbstractActivity {

    @Bind(R.id.unverified_photo_circle) CircleImageView mImageView;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_unverified);
        ButterKnife.bind(this);

        initializeProfilePhoto();
    }

    private void initializeProfilePhoto() {
        mUser.loadUserImage(this, mImageView);
    }
}
