package blueprint.com.sage.signUp;

import android.os.Bundle;

import com.squareup.picasso.Picasso;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.AbstractActivity;
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

        Picasso picasso = Picasso.with(this);

        if (mUser.getImageUrl() == null) {
            picasso.load(R.drawable.default_profile).into(mImageView);
        } else {
            picasso.load(mUser.getImageUrl()).into(mImageView);
        }
    }
}
