package blueprint.com.sage.shared.interfaces;

import android.content.SharedPreferences;

import com.google.android.gms.common.api.GoogleApiClient;

import blueprint.com.sage.models.School;
import blueprint.com.sage.models.Semester;
import blueprint.com.sage.models.User;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 11/23/15.
 */
public interface BaseInterface {
    User getUser();
    void setUser(User user);
    School getSchool();
    NetworkManager getNetworkManager();
    SharedPreferences getSharedPreferences();
    GoogleApiClient getGoogleApiClient();
    Semester getCurrentSemester();
}
