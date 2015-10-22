package blueprint.com.sage.utility.model;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import blueprint.com.sage.models.School;
import blueprint.com.sage.models.User;
import blueprint.com.sage.utility.network.NetworkManager;
import lombok.Data;

/**
 * Created by charlesx on 10/21/15.
 */
public @Data class UserSchoolManager {

    private User user;
    private School school;
    private Context context;
    private SharedPreferences preferences;

    public UserSchoolManager(Context context, SharedPreferences preferences) {
        this.preferences = preferences;
        this.context = context;
        setUpModels();
    }

    private void setUpModels() {
        // TODO: replace this with getString after kelsey merges stuff.
        String userString = preferences.getString("user", "");
        String schoolString = preferences.getString("school", "");

        ObjectMapper mapper =  NetworkManager.getInstance(context).getObjectMapper();

        School school = null;
        User user = null;
        try {
            user = mapper.readValue(userString, new TypeReference<User>() {});
            school = mapper.readValue(schoolString, new TypeReference<School>() {});
        } catch (Exception e) {
            Log.e(getClass().toString(), e.toString());
        }

        this.user = user;
        this.school = school;
    }
}
