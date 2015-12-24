package blueprint.com.sage.checkIn;

import android.os.Bundle;

import blueprint.com.sage.R;
import blueprint.com.sage.checkIn.fragments.CreateCheckInFragment;
import blueprint.com.sage.shared.activities.NavigationAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 10/16/15.
 * Check in Activity
 */
public class CheckInActivity extends NavigationAbstractActivity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, CreateCheckInFragment.newInstance(), this);
    }
}
