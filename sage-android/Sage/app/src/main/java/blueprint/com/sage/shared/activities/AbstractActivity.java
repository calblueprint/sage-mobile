package blueprint.com.sage.shared.activities;

import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
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
public abstract class AbstractActivity extends AppCompatActivity {

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

    public User getUser() { return mUser; }
    public void setUser(User user) { mUser = user; }

    public School getSchool() { return mSchool; }
    public void setSchool(School school) { mSchool = school; }

    public NetworkManager getNetworkManager() { return mNetworkManager; }
    public SharedPreferences getSharedPreferences() { return mPreferences; }
}
