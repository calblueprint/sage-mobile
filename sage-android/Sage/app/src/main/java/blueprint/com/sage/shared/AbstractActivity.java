package blueprint.com.sage.shared;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.util.Log;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import blueprint.com.sage.R;
import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 10/24/15.
 * Application activity that most activities inherit from
 */
public abstract class AbstractActivity extends FragmentActivity {

    protected SharedPreferences mPreferences;
    protected NetworkManager mNetworkManager;

    protected User mUser;
    protected School mSchool;

    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        mPreferences = getSharedPreferences(getString(R.string.preferences), MODE_PRIVATE);
        mNetworkManager = NetworkManager.getInstance(this);

        // LOGOUT USER HERE IF NO CREDENTIALS
        setUpUser();
        setUpSchool();
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

    protected User getUser() { return mUser; }
    protected void setUser(User user) { mUser = user; }

    protected School getSchool() { return mSchool; }
    protected void setSchool(School school) { mSchool = school; }

    protected NetworkManager getNetworkManager() { return mNetworkManager; }
    protected SharedPreferences getSharedPreferences() { return mPreferences; }
}
