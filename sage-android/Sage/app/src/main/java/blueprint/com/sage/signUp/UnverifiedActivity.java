package blueprint.com.sage.signUp;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.shared.AbstractActivity;
import butterknife.ButterKnife;

/**
 * Created by charlesx on 10/24/15.
 * Activity shown when a user isn't verified yet.
 */
public class UnverifiedActivity extends AbstractActivity {



    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_unverified);
        ButterKnife.bind(this);
    }
}
