package blueprint.com.sage.shared.activities;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.places.Places;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
import blueprint.com.sage.shared.interfaces.BaseInterface;
import blueprint.com.sage.utility.network.NetworkManager;
import blueprint.com.sage.utility.network.NetworkUtils;

/**
 * Created by charlesx on 10/24/15.
 * Application activity that most activities inherit from
 */
public abstract class AbstractActivity extends AppCompatActivity implements BaseInterface {

    protected SharedPreferences mPreferences;
    protected NetworkManager mNetworkManager;
    protected GoogleApiClient mGoogleApiClient;

    protected User mUser;
    protected School mSchool;
    protected Semester mCurrentSemester;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mPreferences = getSharedPreferences(getString(R.string.preferences), MODE_PRIVATE);
        mNetworkManager = NetworkManager.getInstance(this);
        mGoogleApiClient = new GoogleApiClient.Builder(this)
                .addApi(LocationServices.API)
                .addApi(Places.GEO_DATA_API)
                .addApi(Places.PLACE_DETECTION_API)
                .build();

        if (!NetworkUtils.isVerifiedUser(this, mPreferences))
            NetworkUtils.logoutCurrentUser(this);

        setUpUser();
        setUpSchool();
        setUpCurrentSemester();
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

    private void setUpUser() {
        String userString = mPreferences.getString(getString(R.string.user), "");

        try {
            ObjectMapper objectMapper = mNetworkManager.getObjectMapper();
            mUser = objectMapper.readValue(userString, new TypeReference<User>() {});
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
    }

    private void setUpSchool() {
        String schoolString = mPreferences.getString(getString(R.string.school), "");

        try {
            ObjectMapper objectMapper = mNetworkManager.getObjectMapper();
            mSchool = objectMapper.readValue(schoolString, new TypeReference<School>() {});
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
    }

    private void setUpCurrentSemester() {
        String currentSemesterString = mPreferences.getString(getString(R.string.current_semester), "");

        try {
            ObjectMapper objectMapper = mNetworkManager.getObjectMapper();
            mCurrentSemester = objectMapper.readValue(currentSemesterString, new TypeReference<Semester>() {});
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }
    }

    public User getUser() { return mUser; }
    public void setUser(User user) { mUser = user; }
    public School getSchool() { return mSchool; }
    public Semester getCurrentSemester() { return mCurrentSemester; }
    public NetworkManager getNetworkManager() { return mNetworkManager; }
    public SharedPreferences getSharedPreferences() { return mPreferences; }
    public GoogleApiClient getGoogleApiClient() { return mGoogleApiClient; }
}
