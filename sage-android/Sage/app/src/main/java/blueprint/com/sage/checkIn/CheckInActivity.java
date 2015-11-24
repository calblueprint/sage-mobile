package blueprint.com.sage.checkIn;

import android.content.SharedPreferences;
import android.os.Bundle;

import com.google.android.gms.common.api.GoogleApiClient;

import blueprint.com.sage.R;
import blueprint.com.sage.checkIn.fragments.CheckInMapFragment;
import blueprint.com.sage.shared.activities.NavigationAbstractActivity;
import blueprint.com.sage.shared.interfaces.CheckInInterface;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 10/16/15.
 * Check in Activity
 */
public class CheckInActivity extends NavigationAbstractActivity implements CheckInInterface {
    private GoogleApiClient mGoogleApiClient;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragUtils.replace(R.id.container, CheckInMapFragment.newInstance(), this);
    }

    public boolean hasPreviousRequest() {
        SharedPreferences preferences = getSharedPreferences();
        return !preferences.getString(getString(R.string.check_in_start_time), "").isEmpty() &&
                !preferences.getString(getString(R.string.check_in_end_time), "").isEmpty();
    }
}
