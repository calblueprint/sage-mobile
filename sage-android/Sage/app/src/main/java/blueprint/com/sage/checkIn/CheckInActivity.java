package blueprint.com.sage.checkIn;

import android.content.SharedPreferences;
import android.os.Bundle;

import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationServices;

import blueprint.com.sage.R;
import blueprint.com.sage.checkIn.fragments.CheckInMapFragment;
import blueprint.com.sage.shared.NavigationAbstractActivity;
import blueprint.com.sage.utility.view.FragUtils;

/**
 * Created by charlesx on 10/16/15.
 * Check in Activity
 */
public class CheckInActivity extends NavigationAbstractActivity {
    private GoogleApiClient mGoogleApiClient;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initializeGoogleApiClient();
        FragUtils.replace(R.id.check_in_container, CheckInMapFragment.newInstance(), this);
    }

    @Override
    public void onStart() {
        super.onStart();
        if (mGoogleApiClient != null)
            mGoogleApiClient.connect();
    }

    @Override
    public void onStop() {
        super.onStop();
        if (mGoogleApiClient != null && mGoogleApiClient.isConnected())
            mGoogleApiClient.disconnect();
    }

    protected synchronized void initializeGoogleApiClient() {
        mGoogleApiClient = new GoogleApiClient.Builder(this)
                                              .addApi(LocationServices.API)
                                              .build();
    }

    public GoogleApiClient getClient() { return mGoogleApiClient; }

    public boolean hasPreviousRequest() {
        SharedPreferences preferences = getSharedPreferences();
        return !preferences.getString(getString(R.string.check_in_start_time), "").isEmpty() &&
                !preferences.getString(getString(R.string.check_in_end_time), "").isEmpty();
    }
}
