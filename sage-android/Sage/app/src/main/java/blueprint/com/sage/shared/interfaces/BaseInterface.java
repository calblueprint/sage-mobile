package blueprint.com.sage.shared.interfaces;

import android.content.SharedPreferences;

import com.google.android.gms.common.api.GoogleApiClient;

import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.utility.network.NetworkManager;

/**
 * Created by charlesx on 11/23/15.
 */
public interface BaseInterface {
    public User getUser();
    public School getSchool();
    public NetworkManager getNetworkManager();
    public SharedPreferences getSharedPreferences();
    public GoogleApiClient getGoogleApiClient();
}
